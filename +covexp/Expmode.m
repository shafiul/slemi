classdef Expmode
    %EXPMODE Experiment mode: enum for different types of experiment
    %   Detailed explanation goes here
    
    enumeration
        SUBGROUP,...        % analyze a subsection of the available models
        SUBGROUP_AUTO, ...  % Automatically managed subgroup
        ALL                 % analyze all models
    end
    
    methods
        function ret = is_subgroup(obj)
            ret = (obj == covexp.Expmode.SUBGROUP) || (obj == covexp.Expmode.SUBGROUP_AUTO);
        end
    end
    
end

