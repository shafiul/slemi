function [total, mymax] = rt()
%RT Returns duration (hours) of running the covexp.covcollect experiments
%   How many CPU hours were spent for the EMI phases up to actual EMI
%   generation. Returns total (hours), max (seconds)
% Using the max hours to approximate missing data. When using PARFOR, we
% did not record total duration. 
% To approximate, go to the covexp_results folder:
% find . -type d -name "2018-*" | wc -l will give total experiments
% starting in 2018. Substract from it:
% find . -type d -name "2018-*" -exec find {} -name "covexp_result*" \; | wc -l
% which gives experiment count for which we have data.

% compute from coverage experiments

total = 0;
mymax = 0;

% Legacy covexp

legacy = utility.batch_process(covcfg.RESULT_DIR_COVEXP, 'covexp_result',... % variable name
        [], @process_legacy, '*.mat', false, true); %  subdirs; uniform output

total = total + sum(legacy);
mymax = max(mymax, max(legacy));

% Recent covexp

recent = utility.batch_process(covcfg.RESULT_DIR_COVEXP, 'covexp_result',... 
        {{@(p) utility.starts_with(p, 'covexp_result')}}, @process_legacy, '', true, true); %  filename starts with covexp_result
    
total = total + sum(recent);
mymax = max(mymax, max(recent));

% EMI exps

total = total / 3600; 

end

function ret = process_legacy(data)
    ret = 0;
    % Following experiments were not related to EMI
    ignore_mdl_count = 60;
    
    if ~ isfield(data, 'models') || ~isfield(data, 'total_duration')...
            || isempty(data.total_duration)
        return
    end
    
    m = data.models;
    
    if isempty(m) || length(m) > ignore_mdl_count || ~ isfield(m, 'sys')
        return ; 
    end
    
    if ~ utility.starts_with(m(1).sys, 'sampleModel')
        return
    end
    
    ret = data.total_duration;
    
end
