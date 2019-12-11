function ret = comp_invest(dt_ob)
%COMP_INVEST Summary of this function goes here
%   Detailed explanation goes here

    err_execs = cellfun(@(p)~p.exception.empty(), dt_ob.executions);
    first_err = dt_ob.executions{err_execs};
    if iscell(first_err)
        first_err = first_err{1};
    end
    ret = first_err.exception.get(1); % First Err
end

