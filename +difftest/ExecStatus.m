classdef ExecStatus < uint32
    %EXECSTATUS Summary of this class goes here
    %   Detailed explanation goes here
    
    enumeration
        Idle        (0)     % Inception
        Load        (10)    % model/pre-processed model loaded successfully
        PreExec     (20)    % pre-processed model executes successfully
        Exec        (30)    % Executed successfully
        Done        (100)   % Difftest done with logged signal retrieval
        CompStart   (200)   % Moved to Comparison Framework
        CompRefine  (210)   % Signal data refined 
        CompDone    (300)   % Comparison successful
    end
end

