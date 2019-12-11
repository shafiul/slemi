function [ ret ] = file_extension_filter( p, expected_extensions )
%FILE_EXTENSION_FILTER Returns true if `p`, which is a filename, its
%extension exists in `expected_extensions`
%   Usage: place extensions you want int `expected_extensions` i.e. this is
%   a whitelist
p_extensions = strsplit(p, '.');
ret = any(strcmpi(p_extensions{end}, expected_extensions));
end

