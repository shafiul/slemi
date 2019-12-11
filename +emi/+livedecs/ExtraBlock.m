classdef ExtraBlock < emi.livedecs.Decorator
    % Appends a new block for each "source blocks" in the `inp` cell
    % For concrete example see emi.livedecs.ExtraUnaryMinus
    % obj.hobj.inps contains "source blocks" and (out) ports. Add a new
    % block in the model, then connect from inp -> new block.
    % `inps` is a cell of cell. Outer dimension is for supporing parallel
    % operation. The inner cell is RX2 where R is the number of "source"
    % blocks. This is essential when the newly added block has multiple (R)
    % input ports -- so that none is left unconnected. It's up to you which
    % sources would connect to the newly added block.

    
    properties
        block_type = []; % init this in subclass constractor
        
    end
    
    methods
        function obj = ExtraBlock(varargin)
            % Construct an instance of this class
            obj = obj@emi.livedecs.Decorator(varargin{:});
        end
        
        function configure_block(obj, new_b) %#ok<INUSD>
            % Configure the block BEFORE adding connections
        end
                
        function go(obj, varargin )
            function ret = add_a_blk(inp_blk_prt)                                
                [n_b, ~] = obj.mutant.add_new_block_in_model(obj.hobj.parent, obj.block_type);
                
                obj.configure_block(n_b);
                
                % Add Connections
                try
                    for i = 1: size(inp_blk_prt, 1) % These many sources
                        obj.mutant.add_conn(...
                            obj.hobj.parent,...
                            inp_blk_prt{i, 1},... 
                            inp_blk_prt{i, 2}+1,... % prt#+1
                            n_b, i ...
                        );
                    end
                catch e
                    rethrow(e);
                end
                
                % TODO add new block in compiled registry if needed. If
                % multiple inputs, how to decide?
                
                % Add the newly added block's name and port number -
                % assuming we are adding the OUTPUT ports of this block,
                
                % Watchout - using vertcat below i.e. appending the newly
                % added block to the list of `inps`
                
                % Since using vertcat, all of the inp blk-port would
                % remain. May need to adjust this if new change arrives in
                % the future, e.g. by config param
                ret = vertcat(inp_blk_prt, {n_b, 0}); % 1 would be added in port number
            end
            
            obj.hobj.inps = cellfun(@add_a_blk, obj.hobj.inps, 'UniformOutput', false );
        end
    end
end

