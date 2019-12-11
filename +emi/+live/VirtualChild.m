classdef VirtualChild < emi.live.BaseLive
    %VIRTUALCHILD Wrap a block inside a new virtual child 
    %   virtual child is a virtual subsystem in Simulink
    
    properties
       new_ss;          
       new_ss_h;
    end
    
    methods
        function obj = VirtualChild(varargin)
            %VIRTUALCHILD Construct an instance of this class
            
            obj = obj@emi.live.BaseLive({
                @emi.livedecs.AddVirtualChild
                @emi.livedecs.CopyToChild 
            }, varargin{:} );
        end
        
    end
end

