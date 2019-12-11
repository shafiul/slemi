classdef DeleteDeadAddTypeComp < emi.decs.DeadBlockDeleteStrategy
    %DELETEDEADADDTYPECOMP Summary of this class goes here
    %   WARNING Legacy code, probably before we were pre-processing. Not
    %   tested after refactoring
    
    
    methods
        
        function obj = DeleteDeadAddTypeComp (varargin)
            obj = obj@emi.decs.DeadBlockDeleteStrategy(varargin{:});
        end
        
        function address_unconnected_ports(obj, reconnect, do_s, do_d, sources, dests, parent_sys) %#ok<INUSL>
            %%
            obj.add_type_compatible_blocks(do_s, do_d, sources, dests, parent_sys);
        end
        
        function add_type_compatible_blocks(obj, do_s, do_d, sources, dests, parent_sys)
            %% if `do_s` is true, add a Sink-like block, and connect all
            % block-ports from `sources` --> new Sink-like block.
            % Similarly, connect all block-ports from `dests` if `do_d` is
            % true: "new Source-like block" --> \forall block-ports \in
            % `dests`.
            
            % We chose not to put DTC and reconnect the predecessors and
            % successors of a deleted block. In the following code, use
            % other strategies e.g. putting "sink-like" and/or
            % "source-like" blocks for unconnected ports.
            
            function ret = helper(b, p, is_handling_source)
                %%
                ret = true;
                
                if is_handling_source
                    new_blk_type = 'simulink/Sinks/Terminator';
                else
                    new_blk_type = 'simulink/Sources/Constant';
                end
                
                [new_blk_name, ~] = obj.mutant.add_new_block_in_model(parent_sys, new_blk_type);
                
                % Connect
                
                if ~iscell(b)
                    b = {b};
                end
                
                for i=1:length(b)
                    if is_handling_source
                        s_blk = b{i};
                        s_prt = int2str(p(i));
                        d_blk = new_blk_name;
                        d_prt = '1';
                    else
                        s_blk = new_blk_name;
                        s_prt = '1';
                        d_blk = b{i};
                        d_prt = int2str(p(i));
                    end
                    
                    try
                        add_line(parent_sys, [s_blk '/' s_prt], [d_blk '/' d_prt],...
                            'autorouting','on');
                    catch e
                        disp(e);
                    end
                end
            end
            
            if do_s
                rowfun(@(~, b, p) helper(get_param(b, 'Name'), p + 1, true),sources, 'ExtractCellContents', true);
            end
            
            if do_d
                rowfun(@(~, b, p) helper(get_param(b, 'Name'), p + 1, false),dests, 'ExtractCellContents', true);
            end
        end
        
        function  post_delete_strategy(obj, sources, dests, parent_sys) %#ok<INUSD>
        end
        
    end
end

