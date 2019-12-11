classdef FinalValueComparator < difftest.BaseComparator
    %FINALVALUECOMPARATOR Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        compare_len = false;
    end
    
    methods
        function obj = FinalValueComparator(varargin)
            obj = obj@difftest.BaseComparator(varargin{:});
        end
        
        function compare(obj)
            %%
            obj.compare_wrapper(obj.r.oks{1}, obj.r.oks(2:end));
        end
        
        function compare_single(obj, ground_exec, next_exec, next_exec_idx)
            %%
            % next_exec_idx starts from 1

            f = ground_exec.refined;
            blocks = f.keys();
            
            
            next_refined = next_exec.refined;
            
            next_exec.num_signals = numel(next_refined.keys());
            
            for i = 1 : numel(blocks)
                bl_name = blocks{i};
%                     fprintf('Comparing block: %s\n', bl_name);

                if ~ next_refined.isKey(bl_name)
                    next_exec.num_missing_in_base = next_exec.num_missing_in_base + 1;
                    continue;
                end
                
                next_exec.num_found_signals = next_exec.num_found_signals + 1;
                
                data_1 = f(bl_name);
                data_2 = next_refined(bl_name);

                % Last Data

                num_data_1 = numel(data_1.Data);
                num_data_2 = numel(data_2.Data);

                num_time_1 = numel(data_1.Time);
                num_time_2 = numel(data_2.Time);
                
                if obj.compare_len && ...
                        (num_data_1 ~= num_data_2 || num_time_1 ~= num_time_2)
                    obj.l.error('Time/data len mismatch');
                    e =  MException('RandGen:SL:CompareErrorLen',...
                        sprintf('Len mismatch %s: data1: %d; data2: %d; time1: %d; time2:%d',...
                        bl_name, num_data_1, num_data_2, num_time_1, num_time_2)) ;
                    
                    obj.handle_comp_err(obj.r.comp_diffs, bl_name,...
                        next_exec, [], [], e, next_exec_idx);
                else
                    try
                        d_1 = data_1.Data(numel(data_1.Data));
                        d_2 = data_2.Data(numel(data_2.Data));
                    catch e
                        disp(e)
                        rethrow(e);
                    end

                    t_1 = data_1.Time(numel(data_1.Time));
                    t_2 = data_2.Time(numel(data_2.Time));

                    if (isnan(d_1) && isnan(d_2)) || (d_1 == d_2)
    %                         fprintf('Data No Mismatch\n');
                    else
                        obj.l.error('Data Mismatch!');
                        e = MException('RandGen:SL:CompareErrorData',...
                                sprintf('Data mismatch %s: data1: %f; data2: %f; len1: %d; len2:%d',...
                                bl_name, d_1, d_2, num_data_1, num_data_2 )) ;
                            
                        obj.handle_comp_err(obj.r.comp_diffs, bl_name,...
                        next_exec, d_1, d_2, e, next_exec_idx);
                    end


                    if t_1 == t_2
    %                         fprintf('Time No Mismatch\n');
                    else
                        obj.l.error('Time Mismatch!');
                        e = MException('RandGen:SL:CompareErrorTime',...
                                sprintf('Time mismatch %s: time1: %f; time2: %f; len1: %d; len2:%d',...
                                bl_name, t_1, t_2, num_time_1, num_time_2 )) ;
                            
                        obj.handle_comp_err(obj.r.comp_diffs, bl_name,...
                        next_exec, t_1, t_2, e, next_exec_idx);
                    end
                end
                
            end
        end
        
    end
end

