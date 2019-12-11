function r = get_coverage(r)
%GET_COVERAGE Summary of this function goes here
%   Detailed explanation goes here
r.simdur = [];

r.exception = false;
r.exception_ob = [];

r.blocks = [];
r.numzerocov = [];

r.stoptime_changed = [];

r.loc = []; % Used for Corpus models. For EXPLORE mode, use loc_input

r.duration = [];
end

