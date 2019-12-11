function ext = get_extension(sys)
%GET_EXTENSION Summary of this function goes here
%   WARNING: SYS must be loaded
temp = strsplit( get_param(sys, 'FileName'), '.');
ext = temp{end};
end

