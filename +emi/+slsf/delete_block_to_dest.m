function delete_block_to_dest(parent,block,destinations,is_if_block, replace)
% Delete block -> destination connections

if nargin < 5
    replace = [];
end

rowfun(@(a,b,c) emi.slsf.delete_connection(...
                    parent, block, a, get_param(b, 'Name'), c + 1,...
                    is_if_block, replace, true ...
                ),...
    destinations, 'ExtractCellContents', true, 'ErrorHandler', @utility.rowfun_eh);
end

