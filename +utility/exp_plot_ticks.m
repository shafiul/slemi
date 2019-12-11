function ret = exp_plot_ticks(myticks)
%EXP_PLOT_TICKS Format plot x ticks in 10^x format
%   Detailed explanation goes here
ret = arrayfun(@(p)['10^' int2str(log10(p))],myticks, 'UniformOutput', false);
end

