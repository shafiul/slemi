function [errors] = multi_errors(errors)
%MULTI_ERRORS Get the first one from multi errors
%   Detailed explanation goes here
    errors = cellfun(@first_error, errors, 'UniformOutput', false);
end

function e  = first_error(e)
    if(strcmp(e.identifier, 'MATLAB:MException:MultipleErrors')) 
        e = e.cause{1};
    end
end