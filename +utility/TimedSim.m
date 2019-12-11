classdef TimedSim < handle
    %TIMEDSIM Simulate for a specific time, kill after it.
    %   Detailed explanation goes here
    
    properties
        sys;
        duration;
        sim_status;
        l;                  % logger
        simargs;
        simOut = [];     % Simulation Results
        
        tmp_dir = [];
    end
    
    methods
        function obj = TimedSim(sys, duration, loggerOb, varargin)
            obj.sys = sys;
            obj.duration = duration;
            obj.l = loggerOb;
            
            obj.simargs = covcfg.SIMULATION_ARGS;
            
            if nargin >= 4
                obj.simargs = utility.merge_structs(...
                    {obj.simargs, varargin{1}});
            end
        end
        
        function term(obj)
            % Invoke the term command after compiling
            eval([obj.sys '([], [], [], ''term'')']);
        end
        
        function create_temp(obj, ext)
            % Create a new Simulink model with a random name in a temp dir
            obj.tmp_dir = tempname;
            mkdir(obj.tmp_dir);
            new_name = sprintf('%s_tmp_%d', obj.sys, randi(10^9) );
            full_path = emi.slsf.copy_model(...
                            obj.sys, obj.tmp_dir, new_name, ext);
            obj.l.info('Created temp model: %s', full_path);
            obj.sys = new_name;
        end
        
        function cleanup(obj)
            if ~ isempty(obj.tmp_dir)
                bdclose(obj.sys);
                assert(rmdir(obj.tmp_dir, 's'));
            end
        end
        
        function timed_out = start(obj, varargin)
            % First argument, if present, denotes whether to only compile
            % WARNING timed_out is kept for legacy code. Now we always
            % throw exception when time-out
            % If want to make a temporary copy of the model first, pass 2nd
            % argument: extension of the model e.g. 'slx'
            compile_only = false;
            
            create_temp = false;
            tmp_ext = [];
            
            if nargin >= 2
                compile_only = varargin{1};
            end
            
            if nargin >= 3
                create_temp = true;
                tmp_ext = varargin{2};
            end
            
            if create_temp
                obj.create_temp(tmp_ext);
            end
            
            timed_out = false;
            obj.sim_status = [];
            myTimer = timer('StartDelay', obj.duration, 'TimerFcn', {@utility.TimedSim.sim_timeout_callback, obj});
            start(myTimer);
            e = [];
            try
                if compile_only
                    % Sending the compile command results in error similar
                    % to the bug we reported for slicing. So not reporting
                    % it
                    obj.l.info('COMPILING ONLY %s...', obj.sys);
                    eval([obj.sys '([], [], [], ''compile'')']);
%                     set_param(obj.sys,'SimulationCommand','Update');
                else
                    obj.l.info('Simulating %s...', obj.sys);
                    obj.simOut = sim(obj.sys, obj.simargs);
                end
                
                stop(myTimer);
                delete(myTimer);
                
                obj.l.info('Compile/simulation completed');
            catch e
            end
            
            obj.cleanup();
            
            if ~ isempty(e)
                rethrow(e);
            end
            
            if ~isempty(obj.sim_status) && ~strcmp(obj.sim_status, 'stopped')
                obj.l.info(['Simulation timed-out for ' obj.sys]);
                throw(MException('RandGen:SL:SimTimeout', 'TimeOut'));
            end
        end
    end
    
    methods(Static)
        function sim_timeout_callback(~, ~, extraData)
            try
                extraData.sim_status = get_param(extraData.sys,'SimulationStatus');
                if strcmp(extraData.sim_status, 'running')
                    set_param(extraData.sys, 'SimulationCommand', 'stop');
                end
            catch e
                % Do Nothing
            end
        end
    end
    
end

