function ret = get_all_blocks(sys)
    ret = find_system(sys, 'LookUnderMasks', 'all');
%     ret = find_system(sys, 'LookUnderMasks', 'all', 'Variants', 'AllVariants');    
end