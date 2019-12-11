function ret = run_sim (model, sim_args, l)
    l.info('Simulating %s', model);
    
    simob = utility.TimedSim(...
            model, difftest.cfg.SIMULATION_TIMEOUT, l, sim_args...
        );
    simob.start();
    ret = simob.simOut;
end