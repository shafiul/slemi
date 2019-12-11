classdef SimpleExecutor < difftest.BaseExecutor
    %SIMPLEEXECUTOR Collects coverage
    %   Detailed explanation goes here
    
    properties
        numzerocov;
    end
    
    methods
        
        function obj = SimpleExecutor (varargin)
            obj = obj@difftest.BaseExecutor(varargin{:});
        end
        
        function create_and_open_sys(obj)
            try
                obj.sys = obj.exec_report.sys; % No Pre-execution model

                obj.open_sys();
                
                obj.exec_report.last_ok = difftest.ExecStatus.Load;
            catch e
                utility.print_error(e);
                obj.exec_report.exception = e;
            end
        end
        
        function execution(obj)
            obj.l.info('Coverage Logging...');
            h = get_param(obj.sys, 'handle');
            [obj.simOut, obj.numzerocov] = covexp.get_model_coverage(h, true);
        end
        
    end
end

