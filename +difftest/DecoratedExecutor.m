classdef DecoratedExecutor < utility.Decorator
    %DECORATEDEXECUTOR Base class for implementing decorators for executors
    % See difftest.SignalLoggerExecutor  for an example subclass
    
    methods
        
        function obj = DecoratedExecutor (varargin)
            obj = obj@utility.Decorator(varargin{:});
        end
        
        function pre_execution(obj) %#ok<MANU>
        end
        
        function retrieve_sim_result(obj)
            obj.hobj.exec_report.simdata = obj.hobj.simOut;
        end
         
        function decorate_sim_args(obj)  %#ok<MANU>
        end
        
    end
end

