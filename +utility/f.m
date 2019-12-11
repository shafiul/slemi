function ret = f(fun, var, varargin)
%f Applies correct mapping function based on var's type.
% Useful when you don't know var's type e.g. extracting column from table
if iscell(var)
    ret = cellfun(fun, var, varargin{:});
else % Could be struct array as well
    ret = arrayfun(fun, var, varargin{:});
end
end

