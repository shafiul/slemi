function ret = check_model_compiles(sys, h, ret)
%CHECK_MODEL_COMPILES Compile model to cache data-types of blocks
%   Note: due to Simulink implementation differences, a model might not
%   compile but simulate successfully. This is because compilation is a
%   sperate implementation (likely) and does not respect all of the
%   optimization parameters.
    
    l = logging.getLogger('singlemodel');
    
    simob = utility.TimedSim(sys, covcfg.SIMULATION_TIMEOUT, l);
    
    my_tic = tic();
    
    try
        simob.start(true);
    catch e
        ret.compiles = false;
        ret.compile_exp = e;
    end
    
    e = []; % Do not throw the previous error which is a model issue
    
    if ret.compiles
        
        try % To ensure we terminate the compilation process
            
            %%% Collect compiled data types for blocks
            blocks = covexp.get_all_blocks(h);

            all_blocks = containers.Map();

            for i=1:numel(blocks)
                cur_blk = blocks(i);

                cur_blk_name = getfullname(cur_blk);
                
                try
                    c_data = covexp.experiments.block_compiled_data(...
                        get_param(cur_blk_name, 'CompiledPortDataTypes'), ...
                        utility.na(...
                            cur_blk_name, @(q)Simulink.Block.getSampleTimes(q),...
                            []...
                        )...
                    );

                    
                    cur_blk_name = utility.strip_first_split(cur_blk_name, '/');
                    
                    all_blocks(cur_blk_name) = c_data;
                catch 
                end

            end
                        
            ret.datatypes = all_blocks;
            
            %%% Collect compiled sample times
            
            if isfield(ret, 'blocks')
                st_compiled = cellfun(@(p) utility.na(p,...
                    @(q)get_param(q, 'CompiledSampleTime'), []),...
                    {ret.blocks.fullname}, 'UniformOutput', false);
                
                [ret.blocks.st_compiled] = st_compiled{:};
                
            end
            
            
        catch e
            % Should we not check what went wrong? Yes, at the end of this
            % file we are throwing this :-)
            utility.print_error(e, l);
        end
        
        % Terminate. Turns out a model can compile and then fail to 
        % terminate (e.g. aero_guidance) due to:
        % Error evaluating 'StopFcn' callback of block_diagram.
        try
            simob.term();
        catch e2
            ret.compiles = false;
            ret.compile_exp = e2;
        end
        
    end % compiles
    
    ret.compile_dur = toc(my_tic);
    
    if ~ isempty(e)
        rethrow(e);
    end
end

