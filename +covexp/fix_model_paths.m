function [ models_found ] = fix_model_paths(  )
%FIX_MODEL_PATHS Summary of this function goes here
%   Detailed explanation goes here

models_found = utility.dir_process(covcfg.CORPUS_HOME, '', true, {{@utility.file_extension_filter, {'mdl', 'slx'}}});

end

