function ret = sampletimes(~, ~, ret)
%SAMPLETIMES Collect sample time stats and other block params
%   Assumes you have already collected coverage (Experiment 1)

if ~ isfield(ret, 'blocks') || isempty(ret.blocks)
    return;
%     error('sampletimes experiment depends on coverage collection!');
end

st_param = cellfun(@(p) utility.na(p, @(q)get_param(q, 'SampleTime'), []),...
    {ret.blocks.fullname}, 'UniformOutput', false);

tsamp = cellfun(@(p) utility.na(p, @(q)get_param(q, 'tsamp'), []),...
    {ret.blocks.fullname}, 'UniformOutput', false);

mask_types = cellfun(@(p) utility.na(p, @(q)get_param(q, 'MaskType'), []),...
    {ret.blocks.fullname}, 'UniformOutput', false);

depth = cellfun(@(p)numel(strsplit(p, '/')), {ret.blocks.fullname},...
    'UniformOutput', false);

not_action = cellfun(@cps.slsf.is_blk_non_action_ss, {ret.blocks.fullname},...
    'UniformOutput', false);

[ret.blocks.st_param] = st_param{:};
[ret.blocks.tsamp] = tsamp{:};
[ret.blocks.masktype] = mask_types{:};
[ret.blocks.depth] = depth{:};

[ret.blocks.not_action] = not_action{:};

end

