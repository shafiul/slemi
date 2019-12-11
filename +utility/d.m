function ret = d(fun)
%D Returns a dummy output executing a function fun
%   Useful when you don't care about the return output. Functions like
%   cellfun require a return value anyway
ret = true;
fun();
end

