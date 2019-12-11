classdef DeleteDeadAddSaturation < emi.decs.DeadBlockDeleteStrategy
    %DELETEDEADADDSATURATION Add a saturation block after deleting a dead
    %block which would always output zero to preserve semantics in live
    %path
    
    
    methods
        
        function obj = DeleteDeadAddSaturation (varargin)
            obj = obj@emi.decs.DeadBlockDeleteStrategy(varargin{:});
        end
        
        function post_delete_strategy(obj, sources, dests, parent)
            blk_type = 'simulink/Discontinuities/Saturation';
            
            function blk_config_params = helper(blk_config_params, ~)
                blk_config_params.UpperLimit = '0';
                blk_config_params.LowerLimit = '0';
                blk_config_params.ZeroCross = 'off';
            end
            
            ret = obj.mutant.add_block_in_middle(sources, dests, parent,...
                blk_type, @helper);
            
            % Saturation block cannot accept boolean. For now just make
            % sure inputs are not boolean. If they are, we may put DTC in
            % the future.
            
            for i=1:numel(ret)
                cur = ret{i};
                
                % New block's input type is source block's outport type
                
                n_blk_input_type = obj.mutant.get_compiled_type(parent,...
                    cur.s_blk, 'Outport', cur.s_prt);
                
                assert(~ strcmpi(n_blk_input_type, 'boolean'));
            end
        end
    end
end

