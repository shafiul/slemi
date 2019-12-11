function [ ret ] = mutate_single_model(exp_no, model_data, exp_data )
%MUTATE_SINGLE_MODEL wrapper to ModelMutator object calls
%   Detailed explanation goes here
mutator = emi.SimpleModelMutator(exp_data, exp_no, model_data);

mutator.go();

ret = mutator.result.is_ok() &&...
    mutator.result.are_mutants_ok() && ...
    mutator.result.difftest_ok();

delete(mutator);
clear mutator;
end

