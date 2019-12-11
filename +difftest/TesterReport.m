classdef TesterReport < handle
    %TESTERREPORT Result of one BaseTester operation
    %   Detailed explanation goes here
    
    properties
        %% Prior to comparison
        % utility.cell elements contain report for each SUT 
        % configuration executions. After get_report call becomes cell
        executions;   
        
        % Executions which did not errored. Would be sent for comparison.
        % This is populated when calling the aggregator. Will not be
        % available in the final report to reduce memory usage, and only
        % indices will be available in oks_idx field.
        oks;    % cell.
        oks_idx; % matrix
        
        % ALL executions RAN successfully (NOT checking comparisons)
        is_ok = false; 
        
        exception;      % utility.cell
        
        % Which execution # caused the exception? (indices)
        exc_config;     % utility.cell
        exc_shortname;  % utility.cell
        
        % is_ok value of the execution report which caused error. If no
        % error has occured, this should have ExecStatus.Done
        exc_last_ok;    % utility.cell
        
        %% During Comparison
        % Work on `oks` cell: each element is a running configuration for
        % which you can get logged signal.
        
        % Aggregators: coverage and comparison errors
        cov_diffs;         % map of coverage errors (cov diffs)
        comp_diffs;        % map of comparison errors 

        % Are followings used? Looks like they are not!
        
        is_comp_ok = []; % Will be set to boolean when aggregator runs 
        
        %% Runtime
        
        total_duration = 0;
        
    end
 
    
    methods
        
        function obj = TesterReport()       
            obj.exception = utility.cell();
            obj.exc_config = utility.cell();
            obj.exc_shortname = utility.cell();
            
            obj.exc_last_ok = utility.cell();
            
            obj.cov_diffs = containers.Map;
            obj.comp_diffs = containers.Map;
        end
        
        function ret = get_report(obj)
            ret = utility.get_struct_from_object(obj, containers.Map(...
                {'oks', 'executions'}, {1, 1}));
            
%             if ~ isempty(obj.oks) % unsure why this check was needed
                ret.executions = obj.executions.map(@(p)p.get_report(), false);
%             end
        end
        
        function ret = are_oks_ok(obj)
            %% Whether all COMPARISONS ran successfully
            % `oks` data structure contains executions which compiled and
            % executed successfully and was eventually sent to diff-test.
            ret = all(cellfun(@(p)p.is_ok() , obj.oks));
        end
        
        function aggregate_before_comp(obj)
            %% Computes result before running the comparison framework
            % This functin is called by BaseTester before running
            % comparison
            
            okays = utility.cell(obj.executions.len);
            
            for i=1:obj.executions.len
                cur = obj.executions.get(i);
                obj.exc_last_ok.add(cur.last_ok);
                
                if ~ cur.is_ok()
                    obj.exception.add( cur.exception);
                    obj.exc_config.add( i);
                    obj.exc_shortname.add( cur.id);
                else
                    okays.add(i);
                end
            end
            
            obj.oks_idx = okays.get_mat();
            obj.oks = obj.executions.get_cell(obj.oks_idx);
            
            obj.is_ok = okays.len == obj.executions.len;
        end
        
        function aggregate_after_comp(obj)
            obj.is_comp_ok = all(cellfun(@(p)p.is_ok(),obj.oks));
%             n_oks = numel(obj.oks);
%             okays = utility.cell(n_oks);
%             
%             for i=1:n_oks
%                 cur = obj.oks{i};
%                 
%                 if ~ cur.is_ok()
%                 else
%                 end
%             end
        end
    end
 
end

