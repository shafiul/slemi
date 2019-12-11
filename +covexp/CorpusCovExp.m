classdef CorpusCovExp < covexp.BaseCovExp
    %CORPUSCOVEXP Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
    end
    
    methods
        
        function obj = CorpusCovExp(varargin)
            obj = obj@covexp.BaseCovExp(varargin{:});
        end
        
        function init_data(obj)            
            load(covcfg.CORPUS_COV_META);
            
            if isempty(covcfg.CORPUS_GROUP)
                obj.models = {cov_meta.sys};
            else
                obj.models = utility.filter_struct(cov_meta, 'group', 'sys', covcfg.CORPUS_GROUP);
            end
            
            if obj.USE_MODELS_PATH
                obj.models_path = cell(size(obj.models));
                
                for i=1:numel(obj.models_path)
                    if isempty(cov_meta(i).path) || strcmp(cov_meta(i).group, 'tutorial')
                        obj.models_path{i} = '';
                    else
                        tmp = cov_meta(i).path;
                        obj.models_path{i} = [covcfg.CORPUS_HOME filesep...
                            strjoin(tmp(1:end-1), filesep)]; % except extension
                    end
                end
                
            end
        end
        
    end
    
end

