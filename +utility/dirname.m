function ret = dirname(filename)
%DIRNAME Summary of this function goes here
%   Detailed explanation goes here
ret = utility.strip_last_split(filename, filesep);
end

