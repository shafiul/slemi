function [ ret ] = date_filter(p, date_from, datetime_format, split_char )
%DATE_FILTER `p` and `date_from` are date-time strings which can be parsed
%according to the `datetime_format` format. Returns if `p` >= `date_from`.
%`p` is also split by `split_char` first, if `split_char` is not empty.
%   TODO write tests

if ~isempty(split_char)
    p = strsplit(p, split_char);
    p = p{1};
end

p = datetime(p,'InputFormat',datetime_format);

date_from = datetime(date_from,'InputFormat', datetime_format);

ret = p >= date_from;

end

