classdef DecoratedMutator < utility.Decorator
    %DECORATEDMUTATOR Base class for all mutators
    %   Detailed explanation goes here
    
    properties
        l = logging.getLogger('DecoratedMutator');
    end
    
    properties (Dependent)
      r;                    % obj.hobj.r
      mutant;               % obj.hobj.r.mutant
    end

    methods
        
        function obj = DecoratedMutator(varargin)
            obj = obj@utility.Decorator(varargin{:});
        end
        
        function ret = get.r(obj)
            ret = obj.hobj.r;
        end
        
        function ret = get.mutant(obj)
            ret = obj.hobj.r.mutant;
        end
        
        
        function preprocess_phase(obj) %#ok<MANU>
        end
        
        function main_phase(obj) %#ok<MANU>
        end
    end
end

