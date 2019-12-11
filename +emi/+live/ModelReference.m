classdef ModelReference < emi.live.BaseLive
    %VIRTUALCHILD Wrap a block inside a new model using Model Referencing 
    %   TO enable sample time inheritence, we use FixedStep solver for the
    %   referenced models.
    
    properties
       new_ss;          
       new_ss_h;
       model_name;
    end
    
    methods
        function obj = ModelReference(varargin)
            %VIRTUALCHILD Construct an instance of this class
            
            obj = obj@emi.live.BaseLive({
                @emi.livedecs.AddModelRef
                @emi.livedecs.CopyToModel 
            }, varargin{:} );
        end
        
    end
end

