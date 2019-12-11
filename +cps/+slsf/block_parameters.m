function ret = block_parameters(blk)
%BLOCK_PARAMETERS Summary of this function goes here
%   Detailed explanation goes here
bp = get_param(gcb, 'ObjectParameters');

bp_fields = fieldnames(bp);
bp_vals = cellfun(@(p)get_param(blk, p), bp_fields, 'UniformOutput', false);

ret = table(bp_fields, bp_vals);

end

