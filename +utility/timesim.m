function ret = timesim(sys)
%TIMESIM Summary of this function goes here
%   Detailed explanation goes here
x = tic();
sim(sys);
ret = toc(x);
end

