function [emi_result, stats_table, cmp_errs] = report(report_loc, aggregate)
% Aggregates all reports in `report_loc` directory. 
% If aggregate is missing then aggregates individual cache results to a 
% file. Otherwise uses it or loades from disc if empty.
% Example:
% report() Aggregate from the latest directory in emi.cfg.REPORTS_DIR
% report('abc') aggregate but from 'abc' directory
% report([], []) don't aggregate. Load from emi.cfg.RESULT_FILE
% report([], data) don't aggregate, use data

    l = logging.getLogger('emi_report');

    if nargin < 2 % Run aggregation
        if nargin < 1 % From latest directory
            report_loc = utility.get_latest_directory(emi.cfg.REPORTS_DIR);

            if isempty(report_loc)
                l.warn('No direcotry found in %s', emi.cfg.REPORTS_DIR);
                return;
            end
            l.info('Aggregating from "latest" directory: %s', report_loc);
        end
        
        emi_result = utility.batch_process(report_loc, 'modelreport',... % variable name and file name should be 'modelreport'
            {{@(p) strcmp(p, 'modelreport.mat')}}, @process_data, '', true, true); % explore subdirs; uniform output
        emi_result = struct2table(emi_result, 'AsArray', true);
    elseif isempty(aggregate) % Use provided aggregated or load from disc
        l.info('Loading aggregated result from disc...');
        readdata = load(emi.cfg.RESULT_FILE);
        emi_result = readdata.emi_result;
    else
        emi_result = aggregate;
    end
    
    emi_result = utility.table_cell(emi_result, 'difftest_r');
    
    utility.tabulate('is_ok', emi_result, 'No Exception and mutant error?', l);
    
    errors = emi_result{~emi_result.is_ok, 'mutants'};
    if ~ isempty(errors)
        l.error('Following experiments errored during mut create:');
        
        mutant_errors = utility.multi_errors(...
                cellfun( @(p)p.exception{1} ,...
                            errors, 'UniformOutput', false) ...
            );
        
        exp_no =  emi_result{~emi_result.is_ok, 'exp_no'};
        exception_ids = cellfun(@(p)p.identifier, mutant_errors, 'UniformOutput', false);
        
        disp(table(exp_no, exception_ids));
    end
    
    stats_table = [];
    
    try
        % Only works if creating one mutant per model. Generalize later
        stats_table = get_stats(emi_result);
    catch e
        l.error('Error getting stats!');
        utility.print_error(e);
    end
    
    % Write in disc
    save(emi.cfg.RESULT_FILE, 'emi_result', 'stats_table');
    
    [~, cmp_errs] = covexp.experiments.reports.do_difftest(emi_result, l);
end

function ret = process_data(data)
    % change data during loading individuals
    ret = data;
    ret.is_ok = isempty(data.exception) && all(...
        cellfun(@(p)isempty(p.exception), data.mutants));
    
    ret.num_mutants = 0;
    
    ret.n_mut_ops = [];
    ret.durations = [];
    
    if ~ isempty(data.exception)
        return;
    end
    
    ret.num_mutants = numel(data.mutants);
    ret.n_mut_ops = cellfun(@(m)m.num_mutation, data.mutants);
    ret.durations = cellfun(@(m)m.duration, data.mutants); % Mutant gen time
end


function [mutants, varargout] = multi_stats(m, varargin)
    % May not work when inputs are not numeric arrays
    mutants = sum(m);  
    varargout = cellfun(@mean, varargin, 'UniformOutput', false);
end

function [stats_table] = get_stats(ret)

    cmpl_d = cellfun(@(p)utility.na(p, @(q)q.compile_duration),ret.mutants);
    
    if ismember('difftest_r', ret.Properties.VariableNames)
        diff_d = cellfun(@(p)utility.na(p, @(q)q.total_duration),...
            ret.difftest_r);
    else
        diff_d = zeros(length(ret), 1);
    end

    % Group by seed model ids
    [G, m_id] = findgroups(ret.m_id);
    [r0, r1, r2, r3, r4] = splitapply(@multi_stats,...
        ret.num_mutants, ret.n_mut_ops, ret.durations, cmpl_d, diff_d,...
        G);
    
    stats_table = table(m_id, r0, r1, r2, r3, r4, 'VariableNames',...
        {'m_id', 'count_mutants', 'avg_mut_ops', 'avg_mut_dur',...
        'avg_compile_dur', 'avg_difftest_dur'});
end