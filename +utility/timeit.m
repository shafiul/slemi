function ret = timeit(fn)
%TIMEIT Summary of this function goes here
%   Detailed explanation goes here
x = tic();
fn();
ret = toc(x);
end

