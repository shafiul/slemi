classdef AddActionSubSystemAssertError < emi.livedecs.AddActionSubSystem
    %ADDACTIONSUBSYSTEM An Action Subsystem which will always trigger error
    %   Useful if this subsystem would never be selected, e.g. can be
    %   connected to always-false outcome
    
    properties
        
    end
    
    methods
        function obj = AddActionSubSystemAssertError(varargin)
            %ADDACTIONSUBSYSTEM Construct an instance of this class
            %   Detailed explanation goes here
            obj = obj@emi.livedecs.AddActionSubSystem(varargin{:});
            
        end
        
        function configure(obj, varargin)
            obj.empty_me(varargin{:});
            obj.add_in_registry();
            
            % Add Error assertion 
            obj.mutant.add_new_block_in_model([obj.hobj.parent '/' obj.hobj.new_ss], 'simulink/Model Verification/Assertion');
        end
        

    end
end

