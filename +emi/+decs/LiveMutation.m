classdef LiveMutation < emi.decs.DecoratedMutator
    %DEADBLOCKDELETESTRATEGY Summary of this class goes here
    %   Detailed explanation goes here
    

    properties
        % skip mutation op if filter returns true.
        % key: mut_op_id, val: lambda
        mutop_skip = containers.Map(...
        );
    
        % mutation-op specific arguments which would be passed to mutation
        % implementers
        mutop_args;
        
        % Blocks which output be used to generate conditions for if blocks
        if_cond_gen_blocks;
        
        % Whether the block can be put inside an action subsystem to
        % implement always true/false mutations.
        valid_for_if_target;
        
        % Keep track of blocks mutated via always-if. 
        % We cannot mutate a block twice as its type change to action ss
        
        if_target_not_mutated; % still not mutated i.e. available for mutation
    
    end
    
    methods
        
        function obj = LiveMutation(varargin)
            obj = obj@emi.decs.DecoratedMutator(varargin{:});
            obj.mutop_args = {};
        end
        
        
        function main_phase(obj)
            %% 
            e = [];
            
            obj.init();
            
            try
                if size(obj.r.live_blocks, 1) == 0
                    obj.l.warn('No live blocks in the original model! Returning from Decorator.');
                    return;
                end

                live_blocks = obj.r.sample_live_blocks();
                live_blocks = cellfun(@(p) [obj.mutant.sys '/' p],...
                    live_blocks, 'UniformOutput', false);

                % blocks may have repeated contents. Use the following if you
                % want to not mutate with replacement.
    %             [live_blocks, blk_idx] = unique(live_blocks);
                blk_idx = ones(length(live_blocks), 1); % repeatation allowed

                cellfun( ...
                            @(p, op) obj.mutate_a_block(p, [], op) ...
                        , live_blocks, obj.r.live_ops(blk_idx));
                
            catch e
                rethrow(e);
            end
            
            if ~isempty(e)
                rethrow(e);
            end
            
        end
        
        function ret = mutate_a_block(obj, block, contex_sys, mut_op_id)
            %% MUTATE A BLOCK `block` using `mut_op`
            
            ret = true;
            
            if iscell(block)
                % Recursive call when `block` is a cell
                for b_i = 1:numel(block)
                    obj.mutate_a_block([contex_sys '/' block{b_i}], contex_sys);
                end
                return;
            end
            
            mut_op = emi.cfg.LIVE_MUT_OPS{mut_op_id} ;
            
            block = obj.change_block(block, mut_op_id);
            
            if isempty(block)
               skip = true; 
            else
                skip = false;
            end
            
            blacklist = emi.cfg.MUT_OP_BLACKLIST{mut_op_id};
            
            skip = skip ||  blacklist.isKey(cps.slsf.btype(block)) ;
            
            % Check if predecessor has constant sample time
            
            if ~ skip
            
                try
                    [connections,sources,destinations] = emi.slsf.get_connections(block, true, true);
                catch e
                    rethrow(e);
                end

                try
                    if mut_op_id == 2 && ~isempty(sources)
                        skip = skip || emi.live.modelreffilter(obj.mutant, sources);
                    end
                catch e
                    rethrow(e);
                end
                
                
                if obj.mutop_skip.isKey(mut_op_id)
                    wo_parent = utility.strip_first_split(block, '/');
                    fn = obj.mutop_skip(mut_op_id);
                    skip =  fn(obj, wo_parent);
                end
                
            end
                         
            
            if skip
                obj.l.debug('Not mutating %s',...
                    block);
                obj.r.n_live_skipped = obj.r.n_live_skipped + 1;
                return;
            end
            
            is_block_not_action_subsystem = all(...
                ~strcmpi(connections{:, 'Type'}, 'ifaction'));
            
            is_if_block = strcmp(get_param(block, 'blockType'), 'If');
            
            if is_if_block || ~is_block_not_action_subsystem
                obj.r.n_live_skipped = obj.r.n_live_skipped + 1;
                return;
            end
            
            [block_parent, this_block] = utility.strip_last_split(block, '/');
            
%             hilite_system(block);
            
            % Pause for containing (parent) subsystem or the block iteself?
            pause_d = emi.pause_for_ss(block_parent, block);
            
            if pause_d
                % Enable breakpoints
                disp('Pause for debugging');
            end
            
            % To enable hilighting and pausing, uncomment the following:
%             emi.hilite_system(block, emi.cfg.DELETE_BLOCK_P || pause_ss);
%             emi.pause_interactive(emi.cfg.DELETE_BLOCK_P || pause_ss, 'Delete block %s', block);

            
            bl = mut_op(obj.r, block_parent, this_block,...
                connections, sources, destinations, is_if_block, obj.mutop_args);
            
            bl.go();
            
            obj.r.n_live_mutated = obj.r.n_live_mutated + 1;
            
            emi.pause_interactive(emi.cfg.DELETE_BLOCK_P, 'Block %s Live Mutation completed', block);
            
        end
        
        function init(obj)
            %%
            
            obj.if_target_not_mutated = ones(size(obj.mutant.blocks, 1), 1);
            
            obj.if_cond_gen_blocks = obj.mutant.blocks( obj.mutant.blocks.usable_sigRange, :);
            
            % Neither If block nor Action subsystem
            tmp = obj.mutant.blocks.blocktype;
            tmp{1} = '';
            obj.valid_for_if_target = ~startsWith(...
                        tmp,...
                        {'If', 'Model', 'Delay'}...
                    ) &...
                obj.mutant.blocks.not_action;
        end
        
        
        function new_block = change_block(obj, block, mut_op)
            %% Change the block before starting mutation. 
            % Some mutation ops just cannot mutate any block.
            
            new_block = block;
            
            if mut_op == 4
                % @emi.live.AlwaysTrue
                % Warning: Currently it applies to both live and dead
                % blocks as no check to skip dead blocks is made.
                new_block = [];
                
                
                if isempty(obj.if_cond_gen_blocks)
                    return;
                end
                
                if_cond_gen_idx = randi(size(obj.if_cond_gen_blocks, 1),1);
                
                if_cond_generator = obj.if_cond_gen_blocks{if_cond_gen_idx, 'fullname' };
                if_cond_generator = if_cond_generator{1};
                
                
                [block_parent, ~] = utility.strip_last_split(if_cond_generator, '/');
                
                if ~isempty(block_parent)
                    block_parent = [block_parent '/'];
                end
                
                % Now select target block which would be mutated. I.e. put
                % in an Action subsystem
                
                
                % Blocks which are in the same subsystem as
                % if_cond_generator. Also cannot be If block or Action
                % Subsystem. And cannot be if_cond_generator itself
                
                desired_depth = numel(strsplit(if_cond_generator, '/')) + 1;
                
                candi_blocks = obj.mutant.blocks{...
                        startsWith(obj.mutant.blocks.fullname, block_parent) &...
                        obj.mutant.blocks.depth == desired_depth & ...
                        obj.valid_for_if_target & ...
                        obj.if_target_not_mutated & ...
                        ~strcmp(obj.mutant.blocks.fullname, if_cond_generator),...
                    'fullname'};
            
                if isempty(candi_blocks)
                    return;
                end
                
                candi_blk_id = randi(size(candi_blocks, 1),1);
                
                candi_fname = candi_blocks{candi_blk_id};
                true_candi_id = find(strcmp(candi_fname, obj.mutant.blocks.fullname));
                
                obj.if_target_not_mutated(true_candi_id) = false;
                
                new_block = [obj.mutant.sys '/' candi_fname];
                
                % Pass args to decorator
                
                % sample time of If cond generator
                candi_block_st = cps.slsf.get_st(obj.mutant.blocks(true_candi_id, :));
                if isempty(candi_block_st)
                    candi_block_st = '-1'; 
                end
                
                obj.l.info('ST candi blk idx %d; name: %s; st: %s', candi_blk_id, new_block, candi_block_st);
                obj.l.info('If cond generator id: %d, name: %s', if_cond_gen_idx, if_cond_generator);
                
                obj.mutop_args = {...
                    obj.if_cond_gen_blocks(if_cond_gen_idx, :),...
                    candi_block_st...
                };
                
                % Update block type
                obj.mutant.blocks.blocktype{true_candi_id} = 'SubSystem';
                obj.mutant.blocks.not_action(true_candi_id) = false;
            end
        end
        
    end
end

