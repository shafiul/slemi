function ret = init_results(exp_indices, override)
    ret = struct;
    ret = covexp.experiments.ds_init.check_model_opens(ret);
    
    for i = 1:numel(exp_indices)
        cur_experi = covcfg.EXP_INITS{exp_indices(i)};
        ret = cur_experi(ret);
    end
    
    if nargin == 2
        ret = utility.merge_structs({ret, override});
    end
end