classdef ExtraUnaryMinus < emi.livedecs.ExtraBlock
    % Adds a new UnaryMinus block in the dataflow path

    
    properties
        
    end
    
    methods
        function obj = ExtraUnaryMinus(varargin)
            % Construct an instance of this class
            obj = obj@emi.livedecs.ExtraBlock(varargin{:});
            obj.block_type = sprintf('simulink/Math\nOperations/Unary Minus');
        end
        
        function ret = is_compat(obj, varargin)
            % Skip mutation if types are not supported
            % Currently prevents unsinged int types as not supported by the
            % unary minus block. 
            ret = ~any(...
                startsWith(...
                    obj.mutant.get_compiled(obj.hobj.blk_full, 'datatype').Inport,...
                    {'ufix', 'uint'} ... % pattern
                ) ...
            );
        end
        
    end
end

