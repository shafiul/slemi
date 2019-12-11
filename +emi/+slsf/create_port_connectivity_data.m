function ret = create_port_connectivity_data(blk,len,port_count_start)
%CREATE_PORT_CONNECTIVITY_DATA Create a port connectivity data structure.
% Note: first column of the return types is garbage and should not be used!
% Use 0 for port_count_start unless you want to skip some ports
my_handle = get_param(blk, 'Handle');

% Sources

new_blk = cell(len, 1);
new_prt = cell(len, 1);

for i=1:len
    new_blk{i} = my_handle;
    new_prt{i} = port_count_start + i-1;
end

ret = table(new_blk, new_blk, new_prt);
end

