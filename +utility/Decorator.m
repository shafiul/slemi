classdef Decorator < handle
    %ABSTRACTDECORATOR Accomodates decorator-pattern like behavior
    %   NOTE: This is not strictly a decorator pattern
    
    properties
        % Forward-passes all methods to hobj i.e. hidden object
        hobj
    end
    
    methods
        function obj = Decorator(hobj)
            %ABSTRACTDECORATOR Construct an instance of this class
            obj.hobj = hobj;
        end
        
    end
end

