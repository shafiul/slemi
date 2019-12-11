classdef AddForEachSubsystem < emi.livedecs.AddActionSubSystem
    % Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        
    end
    
    methods
        function obj = AddForEachSubsystem(varargin)
            %ADDACTIONSUBSYSTEM Construct an instance of this class
            %   Detailed explanation goes here
            obj = obj@emi.livedecs.AddActionSubSystem(varargin{:});
            
            obj.child_type = 'simulink/Ports & Subsystems/For Each Subsystem';
        end
        
        function configure(obj, varargin)
            obj.empty_me(varargin{:});
        end
        

    end
end

