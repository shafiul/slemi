function all_blocks = getBlocksOfLibrary(lib)
    all_blocks = find_system(['simulink/' lib]);
end