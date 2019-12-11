function [ ret ] = nonrunning( models )
%REMOVE_NONRUNNING To remove models which donot run or compile.
%   Detailed explanation goes here

ret = ~ models{:,'exception'};
end

