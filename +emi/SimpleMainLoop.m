classdef SimpleMainLoop < emi.BaseMainLoop
    %SIMPLEMAINLOOP Implementation of BaseMainLoop
    %   Detailed explanation goes here
    
    properties
    end
    
    methods
        function obj = SimpleMainLoop (varargin)
            obj = obj@emi.BaseMainLoop(varargin{:});
        end
    end
    
end

