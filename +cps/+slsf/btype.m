function ret = btype(b)
%BTYPE Get blocktype to uniquely identifiy a Simulink block.
%   Detailed explanation goes here
ret = get_param(b, 'BlockType');

if strcmp(ret, 'SubSystem')
    ret = get_param(b, 'MaskType');
end

end

