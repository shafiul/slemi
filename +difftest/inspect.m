function inspect(difftest_ob, run_sim)
%INSPECT_MODEL Open up models from a difftest object
%   Detailed explanation goes here
l = logging.getLogger('inspect_models');

if nargin <2 
    run_sim = false;
end

if ~isfield(difftest_ob, 'executions')
    l.info('No Execution objects was found. Returning...');
    return;
end

cellfun(@(p)utility.d(@()open_system([p.loc filesep p.sys '_' difftest.cfg.PRE_EXEC_SUFFIX])),...
    difftest_ob.executions);

l.info('Execution Info');

disp(cellfun(@(e)e.id, difftest_ob.executions, 'UniformOutput', false)');

l.info('--Comparison Differences--');

c_d_keys = difftest_ob.comp_diffs.keys();
for i=1:numel(c_d_keys)
    k = c_d_keys{i};
    l.info('%s', k);
    disp( difftest_ob.comp_diffs(k));
end

if ~ run_sim
    return;
end

sim_args = cellfun(@(e) difftest.get_sim_config(e.configs), difftest_ob.executions, 'UniformOutput', false);

cellfun(...
        @(p, args) difftest.run_sim(...
                                        [p.sys '_' difftest.cfg.PRE_EXEC_SUFFIX],...
                                         args, l ...
                                    ), ...
        difftest_ob.executions, sim_args, ...
        'UniformOutput', false ...
    );

end

