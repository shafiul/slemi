classdef ExecConfig < handle
    %EXECCONFIG Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        shortname;
        configs;
    end
    
    properties(Access=protected)
        
    end
    
    methods
        function obj = ExecConfig(shortname, configs)
            obj.shortname = shortname;
            obj.configs = configs;
        end
    end
    
    methods (Access = protected)
        
    end
end

