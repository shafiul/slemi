function print_error(e, l)
%PRINT_ERROR Summary of this function goes here
%   Detailed explanation goes here
err_msg = utility.get_error(e);

if nargin == 2
    l.error(err_msg);
else
    fprintf('%s\n', err_msg);
end

end

