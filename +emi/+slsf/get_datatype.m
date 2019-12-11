function [ret] = get_datatype(p)
%GET_DATATYPE Summary of this function goes here
%   https://www.mathworks.com/help/fixedpoint/ug/fixed-point-numbers.html#br4g2lj-1
% https://www.mathworks.com/help/simulink/slref/fixdt.html

if utility.starts_with(p, 'ufix') || utility.starts_with(p, 'sfix')
    ret = sprintf('fixdt(''%s'')', p);
    return;
end

ret = p;
end


% function ret=handle_fixpt(p, firstpart)
% %% p is like ufix64_En30
%     x = strsplit(p, '_');
%     wordlen = strsplit(x{1}, 'fix');
%     fractionLen = strsplit(x{2}, 'En');
%     ret = sprintf('fixdt(%s,%s,%s)', firstpart, wordlen{2}, fractionLen{2});
% end