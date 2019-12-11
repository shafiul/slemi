function ret = get_block_coverage(covdata, sys, block)
%GET_BLOCK_COVERAGE Summary of this function goes here
%   Detailed explanation goes here
covdata = struct2table(covdata);
ret =  covdata(strcmp(covdata.fullname, [ sys '/' block]), :);
end

