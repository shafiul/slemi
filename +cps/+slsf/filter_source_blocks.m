function ret = filter_source_blocks(blocks)
%FILTER_SOURCE_BLOCKS Return indicies of blocks who are top-level sources
%   Detailed explanation goes here
% 
% if ~istable(blocks)
%     blocks = struct2table(blocks);
% end

[block_types, mask_types] = cps.slsf.get_source_blocks();

ret = rowfun(...
        @(b,m,d)d==2 && (any(strcmp(b, block_types)) ||...
        any(strcmp(m, mask_types))),...
        blocks, 'InputVariables' ,{'blocktype', 'masktype', 'depth'},...
        'OutputFormat', 'uniform'...
    );


end

