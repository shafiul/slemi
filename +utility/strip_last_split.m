function [ ret, stripped_part ] = strip_last_split( p, split_arg )
%STRIP_LAST_SPLIT To remove extension from file name `p`
% set `split_arg` = '.' 
%   Detailed explanation goes here
ret = strsplit(p, split_arg);
stripped_part = ret{end};
ret = strjoin(ret(1:end-1), split_arg);
end

