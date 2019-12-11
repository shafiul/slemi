classdef ExtraUnaryMinusAssert < emi.livedecs.ExtraBlock
    % Adds a new MATLAB function block in the dataflow path to assert that
    % polarity was reversed by a unary minus block
    % To create a different sort of assertion, extend from this class and
    % override the src_file and/or block_type in the constructor

    
    properties
        src_file = []; % Assertion code will be copied from here
    end
    
    methods
        function obj = ExtraUnaryMinusAssert(varargin)
            % Construct an instance of this class
            obj = obj@emi.livedecs.ExtraBlock(varargin{:});
            
            obj.block_type = sprintf('simulink/User-Defined\nFunctions/MATLAB Function');
            obj.src_file = 'uminus.m';
        end
        
        function configure_block(obj, new_b_h)
            full_blk = [obj.hobj.parent '/' new_b_h];
            obj.mutant.config_mlfun(full_blk, obj.src_file, {full_blk});
        end
        
    end
end

