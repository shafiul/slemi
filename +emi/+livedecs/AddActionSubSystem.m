classdef AddActionSubSystem < emi.livedecs.AddVirtualChild
    %ADDACTIONSUBSYSTEM Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        
    end
    
    methods
        function obj = AddActionSubSystem(varargin)
            %ADDACTIONSUBSYSTEM Construct an instance of this class
            %   Detailed explanation goes here
            obj = obj@emi.livedecs.AddVirtualChild(varargin{:});
            
            obj.child_type = 'simulink/Ports & Subsystems/If Action Subsystem';
        end
        
        function configure(obj, varargin)
            obj.empty_me(varargin{:});
            obj.add_in_registry();
        end
        
        function empty_me(obj, varargin)
            % New subsystem is created with some input-output ports. Delete
            % these.
%             Simulink.SubSystem.deleteContents(obj.hobj.new_ss_h);

            % Delete in and out ports
            obj.mutant.delete_line([obj.hobj.parent '/' obj.hobj.new_ss], 'In1/1', 'Out1/1');
            
            obj.mutant.delete_block([obj.hobj.parent '/' obj.hobj.new_ss '/In1']);
            obj.mutant.delete_block([obj.hobj.parent '/' obj.hobj.new_ss '/Out1']);
            
        end
        
        function add_in_registry(obj)
            % Add in registry
            obj.hobj.all_new_ss{numel(obj.hobj.all_new_ss) + 1} = obj.hobj.new_ss;
            obj.hobj.all_new_ss_h{numel(obj.hobj.all_new_ss_h) + 1} = obj.hobj.new_ss_h;
        end
        

    end
end

