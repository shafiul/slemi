classdef envcfg
    %ENVCFG Environment configurations
    %   Copy the envcfg_copy.m file to create envcfg.m (git-ignored)
    %   This was necessary due to issues with environment variables in a
    %   setup. Previously, we used environment variables which was cleaner
    
    properties(Constant = true)
        CORPUS_HOME = ''; % Location of the public model corpus
    end
    
end

