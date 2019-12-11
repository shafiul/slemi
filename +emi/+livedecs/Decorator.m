classdef Decorator < utility.Decorator
    %DECORATOR Decorator for Live Mutation
    %   Mutates a single live block.
    % obj.hobj points to emi.live.BaseLive
    
    properties
        l = logging.getLogger('LiveDecorator');
    end
    
    properties (Dependent)
      r;                    % obj.hobj.r
      mutant;               % obj.hobj.r.mutant
    end
    
    methods
        function obj = Decorator(varargin)
            obj = obj@utility.Decorator(varargin{:});
        end
        
        function ret = get.r(obj)
            ret = obj.hobj.r;
        end
        
        function ret = get.mutant(obj)
            ret = obj.hobj.r.mutant;
        end
        
        function go(obj, varargin) %#ok<INUSD>
        end
        
        function ret = is_compat(obj, varargin) %#ok<INUSD>
            ret = true;
        end
    end
end

