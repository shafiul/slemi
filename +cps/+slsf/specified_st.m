function ret = specified_st(blocks)
% Blocks who have sample time or tsamp specified i.e. not -1
% Only return those who are not both empty, since then we cannot change
% this property anyway.
% 
% if ~istable(blocks)
%     blocks = struct2table(blocks);
% end

ret = rowfun(@(s, t) (~isempty(s{1}) && ~strcmp(s{1}, '-1')) || (~isempty(t{1}) && ~strcmp(t{1}, '-1')) ,...
    blocks(:,{'st_param', 'tsamp',}), 'OutputFormat', 'uniform');

end