function ret = comp_with_pp(sys,~, ret)
% Run differential testing of a model with it's pre-processed version
%   Detailed explanation goes here

l = logging.getLogger('comp_with_pp');

if ret.peprocess_skipped || ret.preprocess_error
    l.info('Skipping difftest of %s since PP creation skipped/errored', sys);
    return;
end

pp = emi.slsf.get_pp_file(sys, ret.loc_input, ret.sys_ext);

h = load_system(pp); %#ok<NASGU>


difftest_exception = [];

try
    
    dt = difftest.BaseTester({sys, pp}, {ret.loc_input, ret.loc_input},...
        covcfg.EXP6_CONFIGS);
    
    dt.go(true, covcfg.EXP6_COMPARATOR);
    
    ret.difftest = dt.r.get_report();
catch e
    difftest_exception = e;
end

% clean up

bdclose(pp);


% Throw any unexpected exception

if ~ isempty(difftest_exception)
    utility.print_error(difftest_exception, l);
    throw(difftest_exception);
end

end

