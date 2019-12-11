classdef BaseLive < utility.DecoratorClient
    %BASELIVE Data model to implement live mutation for only a block
    %   Detailed explanation goes here
    
    properties
       r;               % Instance of Mutant Report
       
       parent;          % path of parent of block to mutate
       blk;             % block to mutate - without full path
       connections;
       sources;         % predecessors
       destinations;    % successors
       is_if_block;
       
       blk_full;        % full path
       
    end
    
    methods
        function obj = BaseLive(decs, r, parent, blk, connections,...
                sources,destinations, is_if_block, varargin)
            %BASELIVE Construct an instance of this class
            obj = obj@utility.DecoratorClient(decs);
            
            obj.r = r;
            obj.parent = parent;
            obj.blk = blk;
            obj.connections = connections;
            obj.sources = sources;
            obj.destinations = destinations;
            obj.blk_full = [parent '/' blk];
            obj.is_if_block = is_if_block;
            
        end
        
        
        function go(obj, varargin)
            % Global and decorator-level compatibility check
            
            try
                if ~ obj.is_compat() || ( ~ all(cell2mat(obj.call_fun_output(@is_compat, varargin{:}))) )
                    obj.r.n_live_skipped = obj.r.n_live_skipped + 1;
                    return;
                end
                
                obj.init();
            catch e
                rethrow(e);
            end
            
            obj.call_fun(@go, varargin{:});
        end
        
        function init(obj, varargin)  %#ok<INUSD>
            % Called before the decorator ``go'' methods
        end
        
        function ret = is_compat(obj, varargin) %#ok<INUSD>
            % Check if this mutaiton is compatible for this block
            ret = true;
        end
        
    end
    
end

