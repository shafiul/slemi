function ret = starts_with(s1, s2)
    % s2: prefix; s1: larger string

    ret = any(strfind(s1, s2) == 1);
end