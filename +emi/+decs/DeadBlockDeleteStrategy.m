classdef DeadBlockDeleteStrategy < emi.decs.DecoratedMutator
    %DEADBLOCKDELETESTRATEGY Summary of this class goes here
    %   Detailed explanation goes here
    
    methods(Abstract)
        % Implement re-connection logic
        post_delete_strategy(obj, sources, dests, parent_sys);
    end
    
    methods
        
        function obj = DeadBlockDeleteStrategy(varargin)
            obj = obj@emi.decs.DecoratedMutator(varargin{:});
        end
        
        function main_phase(obj)
            %% Mutation strategy by removing dead blocks from a model
            if size(obj.r.dead_blocks, 1) == 0
                obj.l.warn('No dead blocks in the original model! Returning from Decorator.');
                return;
            end
            
            blocks_to_delete = obj.r.sample_dead_blocks_to_delete();
            blocks_to_delete = cellfun(@(p) [obj.mutant.sys '/' p], blocks_to_delete, 'UniformOutput', false);
            
            % blocks_to_delete may have repeated contents
            blocks_to_delete = utility.unique(blocks_to_delete);
            
            cellfun(@(p) obj.delete_a_block(p, []), blocks_to_delete);
            
        end
        
        function ret = delete_a_block(obj, block, sys_for_context)
            %% DELETE A BLOCK `block`
            
            ret = true;
            
            if iscell(block)
                % Recursive call when `block` is a cell
                for b_i = 1:numel(block)
                    obj.delete_a_block([sys_for_context '/' block{b_i}], sys_for_context);
                end
                return;
            end
            
            if emi.cfg.SKIP_DELETES.isKey(get_param(block, 'BlockType'))
                obj.l.debug('Not deleting as pre-configured %s', block);
                obj.r.num_skip_delete = obj.r.num_skip_delete + 1;
                return;
            end
            
            obj.r.num_deleted = obj.r.num_deleted + 1;
            
            [connections,sources,destinations] = emi.slsf.get_connections(block, true, true);
            
            [block_parent, this_block] = utility.strip_last_split(block, '/');
            
            % Pause for containing (parent) subsystem or the block iteself?
            pause_d = emi.pause_for_ss(block_parent, block);
            
            if pause_d
                % Enable breakpoints
                disp('Pause for debugging');
            end
            
            % To enable hilighting and pausing, uncomment the following:
            emi.hilite_system(block, emi.cfg.DELETE_BLOCK_P || pause_d);
            emi.pause_interactive(emi.cfg.DELETE_BLOCK_P || pause_d, 'Delete block %s', block);
            
            is_if_block = strcmp(get_param(block, 'blockType'), 'If');
            
            obj.mutant.delete_src_to_block(block_parent, this_block, sources);
            obj.mutant.delete_block_to_dest(block_parent, this_block, destinations, is_if_block);
            
            % Delete if not Action subsystem
            is_block_not_action_subsystem = all(...
                ~strcmpi(connections{:, 'Type'}, 'ifaction'));
            
            emi.hilite_system(block, emi.cfg.DELETE_BLOCK_P, 'fade');
            
            if is_block_not_action_subsystem
                try
                    obj.mutant.delete_block(block);
                catch e
                    utility.print_error(e, obj.l);
                    error('Error deleting block!');
                end
            end
            
            if is_if_block
                % Delete successors? Just first one in the path?
                % Note: should not apply `delete_a_block` recursively to
                % successors, since a successor's predecessor is this block
                obj.l.debug('(!) Deleted If Block!');
                % Do not reconnect!
                obj.address_unconnected_ports(false, true, false, sources, [], block_parent);
            elseif ~ is_block_not_action_subsystem
                obj.l.debug('(!) Did NOT delete Action Subsystem!');
                obj.address_unconnected_ports(true, true, true, sources, destinations, block_parent);
                
                %                 [my_s, my_d] = emi.slsf.get_my_block_ports(block, sources, destinations);
                %                 obj.address_unconnected_ports(true, true, true, my_d, my_s, block_parent);
            else
                obj.l.debug('(!) Deleted regular Block!');
                % Reconnect source - destinations
                % May want to do it randomly. Because leaving them
                % unconnected should not matter and can be good test
                % points. Also, re-connectig might be useful test points.
                obj.address_unconnected_ports(true, true, true, sources, destinations, block_parent);
            end
            
            emi.pause_interactive(emi.cfg.DELETE_BLOCK_P, 'Block %s Delete completed', block);
            
        end
        
        function address_unconnected_ports(obj, reconnect, do_s, do_d, sources, dests, parent_sys)
            %%
            
            if reconnect && do_s && do_d
                
                obj.l.debug('Will reconnect');
                
                obj.post_delete_strategy(sources, dests, parent_sys);
                
                return;
            elseif ~reconnect
                % We deleted an If block and are now trying to put a
                % terminator at the If block's predecessor. Skip doing this
                % as we'd also have to choose a data-type for the
                % terminator (sink-like) for obj.compiled_types
                
                obj.l.debug('Will NOT reconnect');
                return;
            end
            
            error('Did not do anything - this should not be the case');               
        end
        
        
    end
end

