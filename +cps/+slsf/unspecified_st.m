function ret = unspecified_st(blocks)
% Blocks who have sample time or tsamp
%unspecified i.e. -1 or 'inf' i.e. infinity
% Only return those who are not both empty, since then we cannot change
% this property anyway.
% 
% if ~istable(blocks)
%     blocks = struct2table(blocks);
% end

ret = rowfun(@(s, t) ~(isempty(s{1}) && isempty(t{1})) && ( ...
    strcmp('inf', s{1}) || ...
    any(strcmp('-1', {s{1}, t{1}})) ),...
    blocks(:,{'st_param', 'tsamp',}), 'OutputFormat', 'uniform');

end