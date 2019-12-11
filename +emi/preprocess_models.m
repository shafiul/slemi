function ret = preprocess_models(~, ~, ret)
%PREPROCESS_MODELS Preprocess a model for creating mutants
%   Detailed explanation goes here

if ~ ret.compiles || ret.exception
    return;
end

ret.peprocess_skipped = false;

pp_start = tic;

model_data = struct2table(ret, 'AsArray', true);

mutator = emi.ModelPreprocessor(model_data);

mutator.go();

mutant_res = mutator.result.mutants{1};

ret.preprocess_error = mutant_res.preprocess_error;
ret.preprocess_exp = mutant_res.exception;
ret.datatypes = mutator.compiled_types;
ret.pp_duration = toc(pp_start);
end

