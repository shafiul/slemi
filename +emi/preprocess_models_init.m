function ret = preprocess_models_init(ret)
%PREPROCESS_MODELS_INIT Summary of this function goes here
%   Detailed explanation goes here
ret.preprocess_error = false; % If a model is skipped, it is not error
ret.preprocess_exp = [];
ret.peprocess_skipped = true;
ret.pp_duration = [];
end

