classdef cfg
    %CFG Summary of this class goes here
    %   Detailed explanation goes here
    
    properties(Constant = true)
        %% Commonly used 
        
        % How many exepriments to run. In each experiment it's recommended
        % to create only one mutant, although you can create multiple. Some
        % features may break for multiple mutants per experiment.
        NUM_MAINLOOP_ITER = 1; 
        
        % Generate mutants in parallel
        PARFOR = false;
        
        % Non-repeatable experiments, recommended, specially for TACC
        % Set to true to generate random mutants every time
        RNG_SHUFFLE = false;     
        
        % Break from the main loop if any model mutation errors
        STOP_IF_ERROR = false;
        
        %% Differential Testing
        
        % Run differential testing after mutation
        RUN_DIFFTEST = true;
        
        % Creates cartesian product
        SUT_CONFIGS = {
            {difftest.ec.solver_fix}
%             {difftest.ec.opt_off, difftest.ec.opt_on}
%             {difftest.ec.mode_normal, difftest.ec.mode_acc}
        };
    
        % Comparison method
        COMPARATOR = @difftest.FinalValueComparator;
        
        %% Debugging
        
        % Debug/Interactive mode for a particular subsystem or block. 
        % Will pause
        % when mutating this block or ANY block inside a subsystem

        DEBUG_SUBSYSTEM = utility.set(); 
        
        DEBUG_BLOCK = utility.set({
%             'cfblk212'
        });
        
        % Note: when preprocessing models using the covcollect script,
        % don't keep any mutants/parents open. Change
        % followings accordingly.
        
        % don't close a mutant if it did not compile/run
        KEEP_ERROR_MUTANT_OPEN = false;
        KEEP_ERROR_MUTANT_PARENT_OPEN = false;

        % Instead of all seeds, only use interesting seed 
        
        SEED_FILTERS = {
%             @(seeds)seeds.m_id==179 % Seed model ID (``m_id'') 
            };
        
        %% Mutation
        
        % Remove this percentage of dead blocks
        DEAD_BLOCK_REMOVE_PERCENT = 0.5;
        
        LIVE_BLOCK_MUTATION_PERCENT = 0.5;
        
        %% EMI strategies
        
        % Pre-process phases are not run when you invoke `emi.go`. They are
        % invoked by running experiment#3 using `covexp.covcollect`
        % Comment/uncomment to enable or disable mutation strategies
        
        MUTATOR_DECORATORS = {
            @emi.decs.FixSourceSampleTimes                     % Base Mutation
            @emi.decs.TypeAnnotateEveryBlock                  % Base Mutation
            @emi.decs.TypeAnnotateByOutDTypeStr          % Base Mutation
            @emi.decs.DeleteDeadAddSaturation                % Dead Mutation
%             @emi.decs.LiveMutation                                      % Live Mutation
            };
        
        % Live mutation operations and their weights
        LIVE_MUT_OPS = {
            @emi.live.VirtualChild              % 1
            @emi.live.ModelReference      % 2 - Uses FixedStep solver
            @emi.live.Extender                   % 3
            @emi.live.AlwaysTrue              % 4
            @emi.live.ForEach                    % 5
        }; 
        LIVE_MUT_WEIGHTS = [0  0 0 0.5 0.5]; 

        %% Random experiments
        
        % This section only makes sense when RNG_SHUFFLE is false.
        
        % Load previously saved random number seed. This would NOT
        % reproduce previous experiment results, but useful for actually
        % running this tool 24/7 and doing new stuff everytime the script
        % is run.
        
        LOAD_RNG_STATE = false;
        INTERACTIVE_MODE = false;
        
        % If any error occurs, replicate the experiment in next run. Not
        % applicable if RNG_SHUFFLE
        REPLICATE_EXP_IF_ANY_ERROR = true;
        
        %% Preprocessing %%
        
        % Legacy configuration, do not change. This parameter is only
        % respected by the emi.go method, and ignored by covexp.covcollect.
        
        DONT_PREPROCESS = true;
        
        
        MUTANT_PREPROCESSED_FILE_SUFFIX = 'pp';
        
        % Don't rely on this extension since this value is cached already
        % during covcollect process (legacy configuration)
        MUTANT_PREPROCESSED_FILE_EXT = '.slx';
        
        %% Random numbers and reporting file names -- do not change
        
        % Name of the variable for storing random number generator state.
        % We need to save two states because first we randomly select the
        % models we want to mutate. We save this state in
        % `MODELS_RNG_VARNAME_IN_WS`. This is required to replicate a
        % failed experiment. Next, before mutating each of the models, we
        % again save the RNG state in `RNG_VARNAME_IN_WS`
        
        % No need to change the followings
        
        REPORTS_DIR = 'emi_results';
        
        % Result saved when run `emi.report`
        RESULT_FILE = ['workdata' filesep 'emi_exp_result'];
        
        % Save random number seed and others
        WORK_DATA_DIR = 'workdata';
        WS_FILE_NAME_ = 'savedws.mat';
        
        % Global results for an experiment, e.g. total duration
        GLOBAL_REPORT_FILENAME = 'emi_global'; 
        
        % Before generating list of models
        MODELS_RNG_VARNAME_IN_WS = 'rng_state_models';
        % Before creating mutants for *a* model
        RNG_VARNAME_IN_WS = 'rng_state';
        
        % file name for results of a model
        % report will be saved in
        % `REPORTS_DIR`/{EXP_ID}/`REPORT_FOR_A_MODEL_FILENAME`
        REPORT_FOR_A_MODEL_FILENAME = 'modelreport';
        REPORT_FOR_A_MODEL_VARNAME = 'modelreport';
        
        % Save RNG state before creating each mutant
        MUTANT_RNG_FILENAME = 'mutantstate';
        
        % Specify input and output data-type of a newly added block in the
        % compiled data-type registry. Recommended: true
        % Used in cps.SlsfModel::add_block_in_middle
        SPECIFY_NEW_BLOCK_DATATYPE = true;        
        
        %% Which compiler tool chain to target?
        CPS_TOOL = @cps.SlsfModel;
        
        % Don't delete these blocks during dead block removal
        SKIP_DELETES = containers.Map({'Delay', 'UnitDelay'}, {1,1});
        
        INPUT_MODEL_LIST = covcfg.RESULT_FILE
        
        SIMULATION_TIMEOUT = covcfg.SIMULATION_TIMEOUT;
        
        % Force pauses for debugging
        DELETE_BLOCK_P = false;
        
        % logger level
        LOGGER_LEVEL = logging.logging.INFO;
        
        
        %% Internal
        
        MUTANTS_PER_MODEL = 1; % Do not change. 
        
        % Not all blocks are supported by all mutation operators
        MUT_OP_BLACKLIST = {
            utility.set()   % Virtual Child
            utility.set({...   % Referenced Model
                'chirp', 'Clock', 'DigitalClock', 'DiscretePulseGenerator' ,...
                'Ramp', 'Repeating table', 'Repeating Sequence Interpolated' ...
                'Repeating Sequence Stair', 'DiscreteIntegrator' 'SignalGenerator',...
                'Sin', 'Step', 'FromWorkspace', 'ToWorkspace' ...
                'TransportDelay', 'VariableTransportDelay', ...
                'Delay', 'UnitDelay', 'PID 1dof', 'PID 2dof' ,... % not in documentation
                'VariableTransportDelay' ...
            }) % https://www.mathworks.com/help/simulink/ug/inherit-sample-times-for-model-referencing-1.html
            utility.set() % Extender
            utility.set() % Alwasys True
            utility.set({'Delay', 'ToWorkspace'}) % For Each
        };
    end
    
    methods (Static = true)
        
        function validate_configurations()
            assert(~emi.cfg.INTERACTIVE_MODE ||  ~emi.cfg.PARFOR,...
                'Cannot be both interactive and parfor');
            
        end
        
        function ret = WS_FILE_NAME()
            ret = [emi.cfg.WORK_DATA_DIR filesep emi.cfg.WS_FILE_NAME_];
        end
    end
    
end

