function ret = get_preexec_name(sys)
%GET_PREEXEC_NAME get name of the preexec/difftest file
%   Detailed explanation goes here
ret = sprintf('%s_%s', sys, difftest.cfg.PRE_EXEC_SUFFIX);
end

