classdef CoverageComparator < difftest.BaseComparator
    %COVERAGECOMPARATOR Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
    end
    
    methods
        
        function obj = CoverageComparator (varargin)
            obj = obj@difftest.BaseComparator(varargin{:});
        end
        
        function refine_a_execution(~, exec_report)
            exec_report.refined = containers.Map;
              
            for j = 1:length(exec_report.covdata) % struct array
                
                new_data = struct;

                s_dataset = exec_report.covdata(j);

                new_data.percentcov = s_dataset.percentcov;

                % get block name
                bp = s_dataset.fullname; 
                
                % Remove model's name
                bp = utility.strip_first_split(bp, '/', '/'); 
                
                if strcmp(bp, '')
                    continue
                end
                
                exec_report.refined(bp) = new_data;
            end
        end
        
        function compare(obj)
            %%
            obj.compare_wrapper(obj.r.oks{1}, obj.r.oks(2:end));
        end
        
        function compare_single(obj, ground_exec, next_exec, next_exec_idx)
            %%

            f = ground_exec.refined;
            blocks = f.keys();
            
            next_refined = next_exec.refined;
            
            % Actually, num_signals indicate number of blocks since we are
            % interested in a block's coverage, not individual output
            % signals coming out of it.
            next_exec.num_signals = numel(next_refined.keys());
            
            for i = 1 : numel(blocks)
                bl_name = blocks{i};

                if ~ next_refined.isKey(bl_name)
                    next_exec.num_missing_in_base = next_exec.num_missing_in_base + 1;
                    continue;
                end
                
                next_exec.num_found_signals = next_exec.num_found_signals + 1;
                
                data_1 = f(bl_name).percentcov;
                data_2 = next_refined(bl_name).percentcov;
                
                
                % check coverage
                
                e = [];
                
                if isempty(data_1) && isempty(data_2)
                elseif isempty(data_1) || isempty(data_2)
                    obj.l.error('Coverage mismatch for block %s - one is empty. Values: %f; %f',...
                            bl_name, data_1, data_2);
                        e = MException('RandGen:SL:CompareErrorCov',...
                        sprintf('Coverage mismatch for block %s - one is empty. Values: %f; %f',...
                            bl_name, data_1, data_2) ) ;
                elseif data_1 ~= data_2
                        obj.l.error('Coverage mismatch for block %s. Values: %f; %f',...
                            bl_name, data_1, data_2);
                        e = MException('RandGen:SL:CompareErrorCov',...
                        sprintf('Coverage mismatch for block %s. Values: %f; %f',...
                            bl_name, data_1, data_2) ) ;
                end
                
                if ~isempty(e)
                    obj.handle_comp_err(obj.r.cov_diffs, bl_name,...
                        next_exec, data_1, data_2, e, next_exec_idx);
                end
            end
        end

    end
end

