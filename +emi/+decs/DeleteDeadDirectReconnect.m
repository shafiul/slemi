classdef DeleteDeadDirectReconnect < emi.decs.DeadBlockDeleteStrategy
    %DELETEDEADDIRECTRECONNECT Summary of this class goes here
    %   After deleting dead blocks directly re-connect them. The problem is
    %   now we can modify in the live region.
    
    
    methods
        
        function obj = DeleteDeadDirectReconnect (varargin)
            obj = obj@emi.decs.DeadBlockDeleteStrategy(varargin{:});
        end
        
        function post_delete_strategy(obj, sources, dests, parent_sys)
            %% Reconncet source->dests without placing any DTC in middle
            
            combs = emi.slsf.choose_source_dest_pairs_for_reconnection(sources, dests);
            
            for i=1:combs.len
                cur = combs.get(i);
                
                try
                    obj.mutant.add_line(parent_sys,...
                        [cur.s_blk '/' int2str(cur.s_prt)],...
                        [cur.d_blk '/' int2str(cur.d_prt)]...
                        );
                    obj.l.debug('Connected %s/%d ---> %s/%d',...
                        cur.s_blk, cur.s_prt, cur.d_blk, cur.d_prt);
                catch e
                    utility.print_error(e);
                    error('src->dest line adding error');
                end
            end
        end
    end
end

