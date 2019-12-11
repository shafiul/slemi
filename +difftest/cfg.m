classdef cfg
    %CFG Summary of this class goes here
    %   Detailed explanation goes here
    
    properties(Constant)
        EXECUTOR = {@difftest.SignalLoggerExecutor};
        COMPARATOR = @difftest.FinalValueComparator;
        
        SIMULATION_TIMEOUT = covcfg.SIMULATION_TIMEOUT;
        
        PRE_EXEC_SUFFIX = 'difftest';
        DELETE_PRE_EXEC_MODELS = false;
        
        % Don't create the pre-exec file if one already exists
        % WARNING: Every time you preprocess seeds using a new logic, make
        % sure to set it to false or clear all the generated difftest files
        PRE_EXEC_SKIP_CREATE_IF_EXISTS = false;
        
        % When running in parallel, make a copy of the model to prevent
        % issues
        COPY_IF_PARFOR = true;
        
        % Don't change
        PARFOR = emi.cfg.PARFOR;
        
    end
    
    
end

