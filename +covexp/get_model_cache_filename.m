function [report_loc] = get_model_cache_filename(sys,model_id, model_path)
%GET_MODEL_CACHE_FILENAME Summary of this function goes here
%   Detailed explanation goes here
if covcfg.USE_MODEL_PATH_AS_CACHE_LOCATION
    assert(~isempty(model_path), 'Model path can not be empty if using model location as cache directory');
    report_loc = [model_path filesep sys '__covdata'];
else
    report_loc = [covcfg.CACHE_DIR filesep num2str(model_id)];
end
end

