function [models, cmp_e_dts, b4_e_dts] = do_difftest(models, l)
%DO_DIFFTEST Report generator for difftest experiments
%   This function is automatically called by covexp.report

l.info('--- Differential Testing (DIFFTEST) Report ---');
cmp_e_dts = [];
b4_e_dts = [];

if isstruct(models) % struct array from covexp.report
    if ~isfield(models, 'difftest')
        l.warn('No difftest result available!');
        return;
    end
    data = {models.difftest};
else % table from emi.report
    if ~ ismember('difftest_r', models.Properties.VariableNames)
        l.warn('No difftest result available!');
        return;
    end
    data = models.difftest_r;
end

n_data = numel(data);

skipped = ones(n_data, 1);
is_exception = zeros(n_data, 1); % executor ran only, no comparison
is_comp_e = zeros(n_data, 1); % Comparsion errors
% ok_phases = zeros(numel(data), 1);

for i=1:numel(data)
    
    cur = data{i};
    
    if ~isempty(cur)
       skipped(i) = false;
       is_exception(i) = ~ cur.is_ok;
       
       if ~ isempty(cur.is_comp_ok)
        is_comp_e(i) = ~ cur.is_comp_ok;
       end
      
    end
    
end

is_comp_e = logical(is_comp_e);

l.info('DIFFtest: Skipped?');
tabulate(skipped);

is_exception = logical(is_exception);

l.info('DIFFTEST (Before comp): Errored?');
tabulate(is_exception);

b4_e_dts = data(is_exception);

if ~ isempty(b4_e_dts)
    before_errs = cellfun(@(p)p.exception.get(1), b4_e_dts, 'UniformOutput', false);
    before_errs = cellfun(@(p)p.get(1), before_errs, 'UniformOutput', false);
    before_errs = utility.multi_errors(before_errs);
    
    l.error('Before comparison (due to signal logging) Errors:');
    before_errs_ids = cellfun(@(p)p.identifier, before_errs, 'UniformOutput', false);
    tabulate(before_errs_ids);
    
    % Show experiments that errored
    b4_err_experiments = find(is_exception);
    idx = 1:length(b4_err_experiments);
    disp(table(idx', b4_err_experiments, before_errs_ids'));
    
    l.error('Errored objects are returned as last return value. Use `difftest.inspect`');
end


% l.info('DIFFtest: completed phases (Non-Done only; not-skipped only)');
% ok_phases = ok_phases(skipped == false);
% tabulate(ok_phases(ok_phases ~= uint32(difftest.ExecStatus.Done)));


l.info('DIFFTEST (After comp): Errored?');
tabulate(is_comp_e);

if any(is_comp_e)
    l.info('Following comps errored');
    disp(find(is_comp_e)');
    
    m_ids = [models.m_id];
    l.info('Following Model IDs: errored');
    disp(m_ids(is_comp_e)); 
    
    l.info('First errored-SUT-config exception  for each errored experiment:');
    
    % Following line may not work when difftest_r is not not available. See
    % above for code where we use `difftest` as the variable name
    cmp_e_dts = data(is_comp_e) ;
    ex_obs = cellfun(@difftest.comp_invest, cmp_e_dts, 'UniformOutput', false);
    l.error('%s', strjoin(cellfun(@(p) utility.get_error(p), ex_obs, 'UniformOutput', false), '\n'));
    
    l.info('Errored experiments are returned in a cell (third (for emi.report) of this function).')
    l.info('Call difftest.inspect with an element of this cell to see the mismatches and open the models.');
end

% Strip out empty data

data = data(~ cellfun(@isempty, data));

rt(data, l);

end


function rt(difftest_data, l)
    rts = cellfun(@(p)p.total_duration,  difftest_data);
    l.info('DIFFTEST total runtime: %f hours', sum(rts)/3600 );
    
end
