classdef AddModelRef < emi.livedecs.AddVirtualChild
    %DECWRAPINCHILDMODEL Adds a new model reference at the same position
    %of the block to be mutated
    %   Detailed explanation goes here
    
    properties
        
    end
    
    methods
        function obj = AddModelRef(varargin)
            %DECWRAPINCHILDMODEL Construct an instance of this class
            obj = obj@emi.livedecs.AddVirtualChild(varargin{:});
            obj.child_type = 'simulink/Ports & Subsystems/Model';
        end
        
        
        function configure(obj, varargin)
            obj.hobj.model_name = sprintf('slforge_mr_%d', randi(10^9));
            try
                new_system( obj.hobj.model_name );
                
                % For sample time inheritence, use fixed solver
                % https://www.mathworks.com/help/simulink/ug/inherit-sample-times-for-model-referencing-1.html
                set_param(obj.hobj.model_name, 'Solver', 'fixed');
            catch e
                bdclose(obj.hobj.model_name);
                obj.l.error('Model name collision... Closing model...');
                rethrow(e);
            end
            load_system(obj.hobj.model_name);
            
            obj.mutant.modelrefs.add(obj.hobj.model_name); % For closing
        end
    end
end

