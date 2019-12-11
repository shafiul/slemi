function delete_src_to_block(parent,block, sources, replace)
% Delete source -> block connections

if nargin < 4
    replace = [];
end

rowfun(@(a,b,c) emi.slsf.delete_connection(...
        parent, get_param(b, 'Name'),...
        int2str(c + 1), block, str2double(a), false, replace, false... 
    ),...
    sources, 'ExtractCellContents', true);

end

