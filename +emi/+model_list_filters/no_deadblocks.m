function [ ret ] = no_deadblocks( models )
%REMOVE_NO_DEADBLOCKS Remove models which has no dead blocks
%   Detailed explanation goes here

ret = cellfun(@(p) ~isempty(p) && p > 0, models{:, 'numzerocov'});
end

