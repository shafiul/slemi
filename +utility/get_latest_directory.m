function ret = get_latest_directory(loc)
%GET_LATEST_DIRECTORY Summary of this function goes here
%   Detailed explanation goes here
ret = [];

alls = utility.dir_process(loc, '', false, {}, true);

if isempty(alls)
    return;
end

max_date = max(datetime(alls(:, 1), 'InputFormat', covcfg.DATETIME_STR_TO_DATE));

% All are in the same directory, so pick any element's directory when
% constructing the full path
ret = [alls{1, 2} filesep datestr(max_date, covcfg.DATETIME_DATE_TO_STR)];

end

