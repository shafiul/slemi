classdef ForEach < emi.live.BaseLive
    % Wrap a block inside a new For Each Subsystem 
    
    properties
       new_ss;          
       new_ss_h;
    end
    
    methods
        function obj = ForEach(varargin)
            % Construct an instance of this class
            
            obj = obj@emi.live.BaseLive({
                @emi.livedecs.AddForEachSubsystem
                @emi.livedecs.ForEachCopyToChild 
            }, varargin{:} );
        end
        
        function ret = is_compat(obj, varargin)
            % Check if this mutaiton is compatible for this block
            % No source blocks
            ret = ~isempty(obj.sources);
        end
        
    end
end

