function ret = strip_root_sys(p)
%STRIP_ROOT_SYS strip the root system name from `p`
%   Detailed explanation goes here
ret = utility.strip_first_split(p, '/', '/');
end

