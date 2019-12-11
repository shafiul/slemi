classdef ec < handle
    %EC Common Execution Configs
    
    properties (Constant)
        opt_off = difftest.ExecConfig('OptOff', struct('SimCompilerOptimization', 'off'));
        opt_on = difftest.ExecConfig('OptOn', struct('SimCompilerOptimization', 'on'));
        
        solver_var = difftest.ExecConfig('VarSlvr', struct('SolverType', 'Variable-step'));
        solver_fix = difftest.ExecConfig('FixSlvr', struct('SolverType', 'Fixed-step'));
        
        mode_normal = difftest.ExecConfig('Nrml', struct('SimulationMode', 'normal'));
        mode_acc = difftest.ExecConfig('Acc', struct('SimulationMode', 'accelerator'));
    end
    
end

