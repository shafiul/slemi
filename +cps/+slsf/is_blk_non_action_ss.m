function ret = is_blk_non_action_ss(block)
%IS_BLK_NON_ACTION_SS If the block is NOT action subsystem
ret = true;

try
    [connections,~,~] = emi.slsf.get_connections(block, false, false);
catch 
    return;
end

ret = all(...
    ~strcmpi(connections{:, 'Type'}, 'ifaction'));
end

