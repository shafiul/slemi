function ret = get_all_top_level_blocks(sys)
    ret = find_system(sys, 'FindAll','On','SearchDepth',1,'type','block');
end