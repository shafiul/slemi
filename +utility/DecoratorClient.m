classdef DecoratorClient < handle
    %DECORATORCONTAINER This class uses decorators i.e. subclasses of
    %utility.AbstractDecorator to implement a decorator-like pattern.
    
    properties
        decorators = [];
    end
    
    methods
        function obj = DecoratorClient(decorators)
            %DECORATORCONTAINER Construct an instance of this class
            assert(iscell(decorators));
            obj.decorators = cellfun(@(p)p(obj), decorators, 'UniformOutput', false);
        end
        
        function call_fun(obj, fun, varargin)
            %% Calls `fun` method of all decorators
            
            for i=1:numel(obj.decorators)
                dec = obj.decorators{i};
                fun(dec, varargin{:});
            end
        end
        
        function out = call_fun_output(obj, fun, varargin)
            %% Calls `fun` method of all decorators, returns output
            out = cell(length(obj.decorators), 1);
            for i=1:numel(obj.decorators)
                dec = obj.decorators{i};
                out{i} = fun(dec, varargin{:});
            end
        end
        
        function delete(obj)
            %% Destructor. Address cyclic dependencies
%             fprintf('Decorator client destructor called!\n');
            try
                for i=1:numel(obj.decorators)
                    try
                        dec = obj.decorators{i};
                        dec.hobj = [];
                        
                        delete(dec);
                        clear dec;
                    catch e
                        fprintf('Error in decorator client destructor!\n');
                        utility.print_error(e);
                    end
                end
                obj.decorators = [];
            catch me
                fprintf('Error in destructor of DecoratorClient!\n');
                utility.print_error(me);
            end
        end
    end
end

