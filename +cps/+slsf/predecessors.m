function src_handles = predecessors(block, sources)
%PREDECESSORS Summary of this function goes here
%   Detailed explanation goes here
if nargin < 2
    sources = [];
end

if isempty(sources)
    [~, sources, ~] = emi.slsf.get_connections(block, true, false);
end

src_handles = utility.c( sources{:, 'SrcBlock'} );

end

