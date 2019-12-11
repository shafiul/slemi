function [my_s, my_d] =  get_my_block_ports(blk, sources, dests)
    my_s = emi.slsf.create_port_connectivity_data(blk, size(sources, 1), 0);
    my_d = emi.slsf.create_port_connectivity_data(blk, size(dests, 1), 0);
end