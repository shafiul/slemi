function p = c(p)
%C Makes `p` a cell if it is not.
%   Detailed explanation goes here

if ~iscell(p)
    p = num2cell(p); % WARNING refarctored from {p}, watch out for issues
end

end

