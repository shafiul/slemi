classdef SimpleModelMutator < emi.BaseModelMutator
    %SIMPLEMODELMUTATOR Implements BaseModelMutator
    %   Detailed explanation goes here
    
    properties
    end
    
    methods
        function obj = SimpleModelMutator (varargin)
            obj = obj@emi.BaseModelMutator(varargin{:});
        end
    end
    
end

