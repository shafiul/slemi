function ret = get_model_simulates(sys, ~, ret)
    l = logging.getLogger('singlemodel');
%     ret = covexp.get_cov_reporttype(ret);
    
    % Does it run within timeout limit?
    sys_src = [ret.loc_input filesep sys covcfg.MODEL_SAVE_EXT];
    
    try
        time_start = tic;
        
        simob = utility.TimedSim(sys, covcfg.SIMULATION_TIMEOUT, l);
        simob.start();
        
        ret.simdur = toc(time_start);
        
        if covcfg.SAVE_SUCCESS_MODELS
            copyfile(sys_src, covcfg.SAVE_SUCCESS_DIR, 'f');
        end
        
    catch e
        ret.exception = true;
        ret.exception_ob = e;
        
        if covcfg.SAVE_ERROR_MODELS
            copyfile(sys_src, covcfg.SAVE_ERROR_DIR, 'f');
        end
     
        covexp.sys_close(sys);
    end 
end
