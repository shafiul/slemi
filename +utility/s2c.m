function data = s2c(data)
%S2C struct-array to cell array
if isstruct(data)
    data = arrayfun(@(p)p, data, 'UniformOutput', false);
end
end

