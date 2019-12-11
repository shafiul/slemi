function [simargs, snames] = get_sim_config(configs)
%GET_SIM_CONFIG Summary of this function goes here
%   Detailed explanation goes here
snames = utility.cell(configs.len);
simargs = utility.cell(configs.len);

for i=1:configs.len
    c = configs.get(i);

    snames.add(c.shortname);
    simargs.add(c.configs);

end

simargs = utility.merge_structs(simargs);

end

