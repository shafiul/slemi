function ret = filename_suffix_filter( p, unexpected_suffix)
%FILENAME_SUFFIX_FILTER Exclude files with the suffix BEFORE file extension
%   E.g. filters OUT files with _pp or _difftest suffix before the
%   extension. 
% WARNING We add an underscore
% Usage: Use `unexpected_suffix` as a blacklist.

without_ext = utility.strip_last_split(p, '.');

if ~iscell(unexpected_suffix)
    unexpected_suffix = {unexpected_suffix};
end


ret = all(cellfun(@(sfx) numel(strsplit(without_ext, ['_' sfx])) == 1,...
    unexpected_suffix));

end

