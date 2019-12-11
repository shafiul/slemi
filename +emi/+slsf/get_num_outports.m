function n_outports = get_num_outports(blk)
%GET_NUM_OUTPORTS Summary of this function goes here
%   Detailed explanation goes here
portHs = get_param(blk, 'PortHandles');
n_outports = numel(portHs.Outport);

end

