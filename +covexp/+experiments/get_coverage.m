function ret = get_coverage(sys, h, ret)
    l = logging.getLogger('singlemodel');
%     ret = covexp.get_cov_reporttype(ret);

    ret.stoptime_changed = handle_stoptime(sys, l);
    ret.loc = get_model_loc(sys);
    
    % Does it run within timeout limit?
    
    try
        time_start = tic;
        
        simob = utility.TimedSim(sys, covcfg.SIMULATION_TIMEOUT, l);
        simob.start();
        
        ret.simdur = toc(time_start);
        
    catch e
        ret.exception = true;
        ret.exception_ob = e;
             
        return;
    end
    
    
    % Now collect coverage!
    
    try
        time_start = tic;
        
        [ret.blocks, ret.numzerocov] = covexp.get_model_coverage(h);
        
        ret.duration = toc(time_start);
        
    catch e
        ret.exception = true;
        ret.exception_ob = e;
    end

end

function ret = get_model_loc(sys)
% Only makes sense for corpus models
    sys_loc = strsplit(get_param(sys, 'FileName'), filesep);
    corpus_loc = strsplit(covcfg.CORPUS_HOME, filesep);
    
    ret = sys_loc(numel(corpus_loc) + 1: end);
end

function new_st =  handle_stoptime(sys, l)
    new_st = [];
    current_st = get_param(sys, 'StopTime');
    try
        current_st = eval(current_st);
        if ~isfinite(current_st)
            l.info('StopTime will be changed');
            new_st = int2str(covcfg.SIMULATION_TIMEOUT * 2); % heuristic
            set_param(sys, 'StopTime', new_st);
        end
    catch e
        utility.print_error(e, l);
    end
end
