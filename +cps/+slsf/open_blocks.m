function open_blocks(blks)
%OPEN_BLOCKS Summary of this function goes here
%   Detailed explanation goes here

load_system('simulink');

sys = 'cyemiOpenBlks';

new_system(sys);
open_system(sys);

e = [];

try
    
    cellfun(@(b, idx)add_block(...
        b, [sys '/b' int2str(idx)] ,'MakeNameUnique','on'),...
        blks, num2cell([1:length(blks)]'));
catch e
    utility.print_error(e);
end

bdclose(sys);

if ~ isempty(e)
    rethrow(e);
end

end


