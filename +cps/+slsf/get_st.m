function [ret] = get_st(data)
%GET_ST Get sample time of a block from data (table of 1 row)
%   Detailed explanation goes here

ret = [];

cmpld = data.st_compiled{1}; % first try the compiled st

if ~isempty(cmpld) && ~iscell(cmpld) && isnumeric(cmpld) % && ~isinf(cmpld)
    ret = ['[' strjoin(...
                arrayfun(@(p)num2str(p), cmpld, 'UniformOutput', false)...
        ) ']'];
elseif ~isempty(data.st_param{1})
    ret = data.st_param{1};
elseif ~isempty(data.tsamp{1})
    ret = data.tsamp{1};
end

end

