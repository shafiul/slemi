classdef Model < handle
    %MODEL CPS Model
    %   Detailed explanation goes here
    
    properties
        l;
        
        sys;
        loc;
        
        blocks;
        compiled_types;
        
        %% Manipulation
        model_builders; % map containing model builders for each subsystem
        rec; % Manipulation recorder
        
        
        modelrefs; % utility.cell for newly created child models. 
        %% Manipulation Stats
        
        newly_added_block_counter = 0;
        newly_added_block_prefix = 'cyemi';
        
        %% MATLAB functions
        loaded_funs; % containers.Map
    end
    
    methods(Abstract)
        copy_from(obj, src)
        load_model(obj)
    end
    
    methods
        function obj = Model(sys, loc, blocks, compiled_types, pp_only)
            obj.l = logging.getLogger('CPSMODEL');
            
            obj.sys = sys;
            obj.loc = loc;
            
            obj.blocks = blocks;
            obj.compiled_types = compiled_types;
            
            obj.model_builders = containers.Map();
            obj.rec = utility.cell();
            
            obj.modelrefs = utility.cell();
            
            obj.loaded_funs = containers.Map();
            
            if ~ pp_only
                % Give a different prefix as names may conflict before pp
                % and after pp
                obj.newly_added_block_prefix = 'emi';
            end
            
            obj.init();
        end
        
        function init(obj) %#ok<MANU>
        end
        
        function ret = filepath(obj)
            ret = [obj.loc filesep obj.sys emi.cfg.MUTANT_PREPROCESSED_FILE_EXT]; % .slx
        end
        
        function ret = filter_block_by_type(obj, blktype)
            %%
            ret = obj.blocks{strcmpi(obj.blocks.blocktype, blktype),1};
        end
        
        function ret = get_new_block_name(obj)
            %%
            ret = sprintf('%s_%d', obj.newly_added_block_prefix, obj.newly_added_block_counter);
            obj.newly_added_block_counter = obj.newly_added_block_counter + 1;
        end
        
        function ret = get_block_prop(obj, blk_wo_root, attr)
            ret = obj.blocks{...
                rowfun( ...
                            @(p)strcmp(p, blk_wo_root),...
                            obj.blocks,...
                            'InputVariables', {'fullname'},...
                            'OutputFormat', 'uniform'),...
                {attr}...
            };
            ret = ret{1};
        end
        
        function ret = get_compiled(obj, blk_full, attr)
            if nargin < 2
                attr = [];
            end
            
            ret = obj.compiled_types(utility.strip_first_split(blk_full, '/'));
            
            if ~ isempty(attr)
                ret = ret.(attr);
            end
        end
        
        function ret = get_compiled_type(obj, parent, block, porttype, prt)
            %% `porttype` can be 'Inport' or 'Outport'
            % `prt` is optional. When omitted returns cell containing all ports.
            % Either use the parent, block style or set empty to parent. In
            % that case block is assumed to be the full path except the
            % model name.
            
            if isempty(parent)
                block_key = block;
            else
                block_key = utility.strip_first_split([parent '/' block], '/');
            end
            
            if ~ obj.compiled_types.isKey(block_key)
                error('Block %s not found in compiled datatypes!', block_key);
            end

            dt = obj.compiled_types(block_key).datatype;
            
            ret = dt.(porttype);
            
            if nargin >= 5
                ret = ret{prt};
            end
        end
        
        function ret = connection_types(obj, conns, porttype)
            %% Get compiled input or output type for connections `conns`
            %   `conns` can be sources or destinations connections 
            % `porttype` can be Inport or Outport
            function ret = helper(b, p)
                % a_conn{2} - block handle; a_conn{3} - port
                blk = utility.strip_first_split(...
                    getfullname(b), '/' ...
                );
                ret = obj.get_compiled_type([], blk, porttype, p+1);
            end
            
            ret = cellfun(@helper,...
                    utility.c(conns{:,2}), utility.c(conns{:,3}), 'UniformOutput', false);
        end
        
        function ret = assign_pred_types(obj, parent, n_blks, sources,...
                add_to_registry, specify_outstr)
            %% Assign each of the n_blks's output types - adds to registry
            % and fixates using OutDataTypeStr. 
            % Does NOT add sample time legend
            
            ret = true;
            
            pred_types = obj.connection_types(sources, 'Inport');
            
            assert(length(n_blks) == length(pred_types));
            
            if isempty(n_blks)
                return;
            end
            
            function ret = helper(a_blk, dt)
                ret = true;
                obj.compiled_reg(...
                    parent, a_blk, [], dt, add_to_registry, specify_outstr...
                    );
            end
            
            try
                cellfun(@helper, n_blks, pred_types);
            catch e
                rethrow(e);
            end
        end

        
        function ret = compiled_reg(obj, parent, n_blk, in_type, out_type,...
                add_to_registry, specifyOut)
            %% Does not register sample time
            
            ret = true;
            
            if ~iscell(in_type)
                in_type = {in_type};
            end
            
            if ~iscell(out_type)
                out_type = {out_type};
            end
            
            fllpath = [parent '/' n_blk];
            
            if add_to_registry
            
                s = struct;
                s(1).Inport= in_type;
                s(1).Outport = out_type;

                obj.compiled_types(utility.strip_first_split(fllpath, '/')) = ...
                    covexp.experiments.block_compiled_data(s, []) ; % no st
            end
            
            % Specify output type
            if specifyOut
                obj.set_param(...
                    fllpath, 'OutDataTypeStr',...
                    emi.slsf.get_datatype(out_type{1})...
                    );
            end
        end
        
        function add_block_compiled_types(obj, parent, src_blk, src_prt, n_blk, n_out_type)
            %% Register new block's input-output datatype and sample time 
            % Register a newly added `n_blk` block's source and destination
            % types in the compiled-types database (i.e. obj.compiled_types)
            % WARNING assumes only one input and output port for the newly
            % added `n_blk`
            
            if ~emi.cfg.SPECIFY_NEW_BLOCK_DATATYPE
                return;
            end
            
            src_outtype = obj.get_compiled_type(parent, src_blk, 'Outport');
            assert(isscalar(src_prt));
            
            n_in_type = src_outtype{src_prt};
            
            if isempty(n_out_type)
                n_out_type = n_in_type;
            end
            
            s = struct;
            s(1).Inport= {n_in_type};
            s(1).Outport = {n_out_type};
            
            % copy sample time legends from source
            tmp = obj.compiled_types(utility.strip_first_split([parent '/' src_blk], '/'));
            tmp.datatype = s;
            obj.compiled_types(utility.strip_first_split([parent '/' n_blk], '/')) = tmp;
        end
        
        function ret = apply_all_preds(obj, sources, fun)
            %% Applies fun to all predecessors - i.e. `sources` the Simulink connections
            % Not used -- test before using!
            preds = cps.slsf.predecessors([], sources);
            preds = cellfun(@getfullname, preds, 'UniformOutput', false);
            ret = cellfun(@(p)fun(obj, p), preds, 'UniformOutput', false);
        end
        
        function config_mlfun(obj, mlfunblk, funpath, fconfigargs)
            %CONFIG_MLFUN Configures a MATLAB Function block by reading source from `funpath`
            % WARNING `mlfunblk` must be a path and not a handle
            %   Copied from MathWorks Documentation: https://www.mathworks.com/help/simulink/ug/creating-an-example-model-that-uses-a-matlab-function-block.html

            blockHandle = find(slroot, '-isa', 'Stateflow.EMChart', 'Path', mlfunblk); %#ok<GTARG>
            % The Script property of the object contains the contents of the block,
            % represented as a character vector. This line of the script loads the
            % contents of the file myAdd.m into the Script property:
            blockHandle.Script = obj.get_mlfun_src(funpath, fconfigargs);
        end
        
        function raw_src = get_mlfun_src(obj, funpath, funconfargs)
            if obj.loaded_funs.isKey(funpath)
                raw_src = obj.loaded_funs(funpath);
                raw_src = raw_src{1};
            else
                funbase = ['+emi' filesep 'mlfunasserts'];
                
                raw_src = fileread([funbase filesep funpath]);
                obj.loaded_funs(funpath) = {raw_src};
            end
            
            raw_src = sprintf(raw_src, funconfargs{:});
        end
        
        
    end
end

