classdef (Sealed) slblockdocfixed < handle
    %SLBLOCKDOCFIXED SL block documentations collected manually
    %   Detailed explanation goes here
    
    properties(Constant = true)
        HIER = 'a';                             % Is Hierarchical model: Model Reference block
        SUBSYS = 'b';                       % For-each subsystems
        SDTYPE = 'c';                         % Source Data type
        DFT = 'd';         % If NOT direct feed-through. Is a 2 element cell. First element is false if the block is ALWAYS NOT DFT. 
        % First element is true if the block is CONDITIONALLY DFT. The
        % second element will list the condition.
        
        OTHER_HIER = 'e';   % Some blocks indirectly cause hierarchy (e.g. IF blocks)
        
        prefix = 'simulink/';
    end
    
    properties 
        source_dtypes;
        d;
    end
    
   methods
       
      function ret = get(obj, blk, prop)
        ret = [];
        
        sn = strsplit(blk, 'simulink/');
        
        if numel(sn) == 2
            blk = sn{2};
        end
        
        if ~ obj.d.contains(blk)
            return;
        end
        
        blkdata = obj.d.get(blk);
        
        if ~ isfield(blkdata, prop)
            return;
        end
        
        ret = blkdata.(prop);
        
      end
      
      function get_block_types(obj, blkname)
        sys = gcs;
        h = add_block([obj.prefix blkname], sys, 'MakeNameUnique','on');
        fprintf('%s \t %s \n', blkname, get_param(h, 'BlockType'));
      end
       
   end
    
   methods (Access = private)
      function obj = slblockdocfixed
          % Output Data Types %
          obj.source_dtypes = utility.map(); 
          obj.source_dtypes.put('Sources/CounterFree_Running', utility.cell({'uint'})); 
          obj.source_dtypes.put('Sources/CounterLimited', utility.cell({'uint'}));
          
          % All Data
          
          obj.d = utility.map();
          
          %%%%% Discrete %%%%%%%%
          
          obj.d.put('DiscreteIntegrator',...    % Discrete/Discrete-TimeIntegrator
              struct(obj.DFT, {false, []}));           % Actually conditional
          
          obj.d.put('UnitDelay',...  % Discrete/Unit Delay
              struct(obj.DFT, {false, []}));  
          
          obj.d.put('Delay',...   % Discrete/Delay; Discrete/Enabled Delay
              struct(obj.DFT, {false, []}));       % Conditional
          
          obj.d.put('DiscreteFilter',... % Discrete/Discrete Filter
              struct(obj.DFT, {false, []}));       % Only when the leading numerator coefficient does not equal zero
          
%           obj.d.put('SubSystem',... % Discrete/Discrete PID Controller
%               struct(obj.DFT, {false, []}));       % Conditional
          
%           obj.d.put('Discrete/Discrete PID Controller (2DOF)',...
%               struct(obj.DFT, {false, []}));       % Conditional
          
          obj.d.put('DiscreteStateSpace',... % Discrete/Discrete State-Space
              struct(obj.DFT, {false, []}));       % Conditional
          
          obj.d.put('Discrete/DiscreteTransfer Fcn',...
              struct(obj.DFT, {false, []}));       % Conditional
          
          obj.d.put('Discrete/DiscreteZero-Pole',...
              struct(obj.DFT, {false, []}));       % Conditional
          
          obj.d.put('Discrete/First-OrderHold',...
              struct(obj.DFT, {false, []}));       
          
          obj.d.put('Discrete/Memory',...
              struct(obj.DFT, {false, []}));       % Conditional
          
          obj.d.put('Discrete/Resettable Delay',...
              struct(obj.DFT, {true, struct('portgt', 1)}));       % Conditional, more conditions exist
          
          obj.d.put('Discrete/Tapped Delay',...
              struct(obj.DFT, {false, []}));       % Conditional
          
          
          %%%%% Ports & Subsystems %%%%
          
          obj.d.put('Ports & Subsystems/Model',...
              struct(obj.HIER, true));
          
          obj.d.put('Ports & Subsystems/For Each Subsystem',...
              struct(obj.SUBSYS, true));
          
          obj.d.put('Ports & Subsystems/Subsystem',...
              struct(obj.SUBSYS, true));
          
            obj.d.put('Ports & Subsystems/If',...
              struct(obj.OTHER_HIER, true));
          
          obj.d.put('Ports & Subsystems/If Action Subsystem',...
              struct(obj.SUBSYS, true));
          
          obj.d.put('Ports & Subsystems/For Iterator Subsystem',...
              struct(obj.SUBSYS, true));
          
          
      end
      
      
      
   end
   methods (Static)
      function singleObj = getInstance
         persistent localObj
         if isempty(localObj) || ~isvalid(localObj)
            localObj = emi.slblockdocfixed;
         end
         singleObj = localObj;
      end
   end
end

