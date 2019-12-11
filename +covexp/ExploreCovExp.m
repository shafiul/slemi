classdef ExploreCovExp < covexp.CorpusCovExp
    %EXPLORECOVEXP Explore a directory and includes all models found in it
    %for experiments, including subdirectories.
    %   TODO NOT TESTED YET!!
    
    properties
        EXPLORE_SUBDIRS = true;
        DATA_VAR_NAME = 'generated_model_list';
        EXPLORE_DIR_LOC ;
    end
    
    methods
        function obj = ExploreCovExp(varargin)
            obj = obj@covexp.CorpusCovExp(varargin{:});
            obj.EXPLORE_DIR_LOC = covcfg.EXPLORE_DIR;
            obj.USE_MODELS_PATH = true;
        end
        
        
        function init_data(obj) 
            if covcfg.GENERATE_MODELS_LIST
                obj.generate_model_list();
            end
            
            generated_list = load(covcfg.GENERATE_MODELS_FILENAME);
            model_lists = generated_list.(obj.DATA_VAR_NAME);
            
            obj.populate_models(model_lists);
        end
        
        function populate_models(obj, models_list)
            obj.models = models_list(:, 1);
            obj.models_path = models_list(:, 2);
        end
        
        function generate_model_list(obj)
            obj.l.info('Generating model list from %s', obj.EXPLORE_DIR_LOC);
            
            models_and_dirs = utility.dir_process(obj.EXPLORE_DIR_LOC, '',...
                true, {
                    {@utility.file_extension_filter, {'slx', 'mdl'}}
                    {@utility.filename_suffix_filter,{emi.cfg.MUTANT_PREPROCESSED_FILE_SUFFIX}}
                    {@utility.filename_suffix_filter,{difftest.cfg.PRE_EXEC_SUFFIX}}
                }, false, {... % isdir_check = false
                            'errors', 'comperrors', 'loglenmismatch',...
                            'othererrors'... % blacklisted dirs
                        });
            
            
            function ret = slforge_date_filter(p)
                targ_dir = strsplit (  p, ['reportsneo' filesep]);
                assert(length(targ_dir) == 2);
                
                ret = utility.date_filter(...
                    targ_dir{2}, covcfg.SLFORGE_DATE_FROM, covcfg.DATETIME_STR_TO_DATE, filesep...
                );
            end
                    
            if covcfg.SOURCE_MODE == covexp.Sourcemode.SLFORGE
                models_and_dirs = models_and_dirs(...
                   cellfun(@slforge_date_filter, models_and_dirs(:,2)), ...
                   : ...
                );
            end
                    
            obj.l.info('Generated list of %d models', size(models_and_dirs, 1));
            
            model_names = cellfun(@(p)utility.strip_last_split(p, '.'), models_and_dirs(:, 1), 'UniformOutput', false);
            models_and_dirs(:, 1) = model_names;
            
            obj.save_generated_list(models_and_dirs);
        end
        
        function save_generated_list(obj, generated_model_list) %#ok<INUSD>
            save(covcfg.GENERATE_MODELS_FILENAME, obj.DATA_VAR_NAME);
        end
    end
    
end

