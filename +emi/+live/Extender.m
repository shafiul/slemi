classdef Extender < emi.live.BaseLive
    % Extend dataflow adding new blocks by forking new dataflow from a
    % block's input line.
    %   Sequentially append blocks on `inps`
    % Uses decorators to perform the actual work. Decorators are subclasses
    % of `emi.livedecs.ExtraBlock`
    % By default adds an UnaryMinus block followed by an Assertion based on
    % the unary minus block's expected behavior
    
    properties
        % Cell. each element is another ?X2 cell containing block and port.
        % ? == number of inputs needed for the block which will be added by
        % the decorator. 
        % E.g. `emi.livedecs.ExtraBlock` adds unary minus by default which
        % needs only one input. So each element of `inps` would be a 1X2
        % cell. 
        % Why `inps` is a cell itself? To support operations for multiple
        % blocks, although I think currently we are only taking the first
        % predecessor of `blocks`, we can easily extend it later.
        inps;   % cell of RX2cell where each r in R is (input block, input port)
    end
    
    methods
        
        function obj = Extender(varargin)
            %
            obj = obj@emi.live.BaseLive({
                @emi.livedecs.ExtraUnaryMinus
                @emi.livedecs.ExtraUnaryMinusAssert
            }, varargin{:} );

        end

        
        function init(obj, varargin)
            % Add block's first input port to inps
            obj.inps = {
                utility.c(obj.sources{1, {'SrcBlock', 'SrcPort'}})    
            }; % only adds block to the first predecessor.
        end
        
        
        function ret = is_compat(obj, varargin)
            % Check if this mutaiton is compatible for this block
            ret = ~isempty(obj.sources);
        end
        
    end
    
end

