classdef BaseMutantGenerator < utility.DecoratorClient
    %BASEMUTANTGENERATOR Create a mutant
    %   Entry point for creating any mutant!
    
    properties
        %%
        r;  % emi.ReportForMutant instance. This object is the data 
        % structure containing everything about mutant.
        
        l = logging.getLogger('MutantGenerator');        
    end
    
    methods
        
        function obj = BaseMutantGenerator(decorators, varargin)
            %% Constructor
            obj = obj@utility.DecoratorClient(decorators);
            
            obj.r = emi.ReportForMutant(varargin{:});
            
            obj.l.setCommandWindowLevel(emi.cfg.LOGGER_LEVEL);
           
        end
        
        function delete(obj)
            try
                delete(obj.r);
                clear obj.r;
            catch e
                fprintf('Error in BaseMutantGennerator destructor\n');
                utility.print_error(e);
            end
        end
        
        function go(obj)
            %%
            obj.init();
            
            obj.l.info(['Begin mutant generation ' obj.r.mutant.sys]);
            
            try
                if obj.handle_preprocess()
                    return;
                end
            catch e
                utility.print_error(e, obj.l);
                obj.l.error('Error during pre-processing');
                obj.r.mutant.close_model();
                rethrow(e);
            end
            
            try
                obj.implement_mutation();
            catch e
                obj.r.mutant.close_model();
                utility.print_error(e, obj.l);
                obj.l.error('Error while mutant generation -- bug in our end');
                throw(MException('emi:exp:crash', int2str(obj.r.exp_data.exp_no)));
%                 rethrow(e);
            end
            
            % TODO do this when filtering list of blocks to be efficient
            obj.l.info('Deleted: %d; Delete skipped: %d', obj.r.num_deleted, obj.r.num_skip_delete);
            obj.l.info('Live Mutated: %d; skipped: %d', obj.r.n_live_mutated, obj.r.n_live_skipped); 
            
            obj.compile_after_mutation();
            
            obj.l.info(['End mutant generation: ' obj.r.mutant.sys]);
        end
        
        function init(obj)
            %%
            obj.handle_preprocess_only_case();
            
            obj.r.create_copy_of_original_and_open();
        end
        
        
        function handle_preprocess_only_case(obj)
            %%
            if ~ obj.r.exit_after_preprocess
                return;
            end
            
            try
                delete(obj.r.mutant.filepath());
            catch
            end
        end
        
        function implement_mutation(obj)
            %% Call decorators to execute mutation strategies!
            rec_tic = tic();
            obj.call_fun(@main_phase);
            obj.r.duration = toc(rec_tic);
        end
        
        function compile_after_mutation(obj)
            rec = tic();
            obj.compile_model_and_return('MUTANT-GEN', true);
            obj.r.compile_duration = toc(rec);
        end
        
        function compile_model_and_return(obj, phase, close_on_success)
            %% phase is a string for logging purpose
            % run mutant
            obj.compile_and_run();
            
            if ~ obj.r.is_ok()
                obj.l.error('Mutant %d did not compile/run: %s', obj.r.my_id, phase);
                
                if emi.cfg.KEEP_ERROR_MUTANT_OPEN
                    % Note: Model is dirty - save manually if want
                    open_system(obj.r.mutant.sys);
                else
                    obj.r.mutant.close_model();
                end
            elseif close_on_success
                % Close Model
                obj.r.mutant.close_model();
            end
        end
        
        function compile_and_run(obj)
            %%
            
            try
                obj.l.info('Compiling/Running mutant...');
                
                simob = utility.TimedSim(obj.r.mutant.sys, covcfg.SIMULATION_TIMEOUT, obj.l);
                simob.start();
                
            catch e
                utility.print_error(e, obj.l);
                obj.r.exception.add(e);
                return;
            end
        end
                
        %% Preprocessing %%
        
        function return_after_this = handle_preprocess(obj)
            %%
            % `return_after_this` indicates if we should return immediately
            % from the calling method.
            return_after_this = false;
            
            if obj.r.dont_preprocess
                return;
            end
            
            % Call decorator functions
            obj.call_fun(@preprocess_phase);
            
            pp_only = obj.r.exit_after_preprocess;
            obj.compile_model_and_return('PREPROCESSING', pp_only);
            
            if ~ obj.r.is_ok() 
                obj.l.error('Compile after preprocess failed');
                obj.r.preprocess_error = true;
                return_after_this = true;
                return;
            end
            
            if pp_only
                obj.l.info('Returning after preprocessing, not creating actual mutants');
                return_after_this = true;
                return;
            end
        end
        
    end
    
end
