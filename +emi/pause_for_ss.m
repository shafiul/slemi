function ret = pause_for_ss(parent, fullblk)
%PAUSE_FOR_SS pause for parent `parent` OR block `blk`
ret = emi.cfg.DEBUG_SUBSYSTEM.isKey(utility.strip_root_sys(parent));

if ret
    return;
end

ret = (nargin == 2) && emi.cfg.DEBUG_BLOCK.isKey(utility.strip_root_sys(fullblk));  

end

