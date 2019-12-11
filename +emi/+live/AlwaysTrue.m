classdef AlwaysTrue < emi.live.BaseLive
    % Wrap a block inside a always True branch
    % Also puts an assertion error in the always-false branch  
    
    properties
       new_ss;          % latest added action subsystem
       new_ss_h;
       
       all_new_ss;      % cell -- all added action subsystems
       all_new_ss_h     % cell
       
       if_cond_gen_blk; % block which generates the if condition
    end
    
    methods
        function obj = AlwaysTrue(varargin)
            %Construct an instance of this class
            
            obj = obj@emi.live.BaseLive({
                @emi.livedecs.AddActionSubSystem
                @emi.livedecs.CopyToChild 
                @emi.livedecs.AddActionSubSystemAssertError
                @emi.livedecs.AddIfBlock
            }, varargin{:} );
        
            obj.all_new_ss = {};
            obj.all_new_ss_h = {};
            
            obj.if_cond_gen_blk = varargin{8};
        end
        
        function ret = is_compat(obj, varargin)
            % Check if this mutaiton is compatible for this block
            ret = ~isempty(obj.sources) && ~isempty(obj.destinations);
        end
        
    end
end

