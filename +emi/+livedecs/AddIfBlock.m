classdef AddIfBlock < emi.livedecs.Decorator
    % Adds If block
    %   Detailed explanation goes here
    
    properties
        is_minrange_inf; % Is the min range infinity
    end
    
    methods
        function obj = AddIfBlock(varargin)
            % Construct an instance of this class
            obj = obj@emi.livedecs.Decorator(varargin{:});
        end
        
        function go(obj, varargin )
            [cond, oblk, oport, minVal] = obj.get_sigrange();
            
            if obj.is_minrange_inf
                o_blk_type = 'double';
            else
                o_blk_type = obj.mutant.get_compiled_type(...
                    obj.hobj.parent, oblk, 'Outport', oport);
            end
            
            [new_if, new_if_h] = obj.mutant.add_new_block_in_model(...
                obj.hobj.parent,...
                'simulink/Ports & Subsystems/If',...
                struct(...
                    'IfExpression', cond,...
                    'SampleTime', obj.hobj.if_cond_gen_blk{2}...
                ),...
                {o_blk_type, [], true, false}... % see Model::compiled_reg
                ); %#ok<ASGLU>
            obj.mutant.add_conn(obj.hobj.parent, new_if, 1, obj.hobj.all_new_ss_h{1}, 'Ifaction');
            obj.mutant.add_conn(obj.hobj.parent, new_if, 2, obj.hobj.all_new_ss_h{2}, 'Ifaction');
            
            obj.mutant.add_conn(obj.hobj.parent, oblk, oport, new_if, 1);
            
            % Add DTC before the IF block
            
            blkname = [obj.hobj.parent '/' new_if];
            [~,sources,~] = emi.slsf.get_connections(blkname, true, false);
            self_as_destination = emi.slsf.create_port_connectivity_data(blkname, size(sources, 1), 0);
            ret = obj.mutant.add_DTC_before_block(blkname, sources, self_as_destination);
            
            % Add Delay block before the newly added DTC to prevent invalid
            % data dependency loops
            
            ret = ret{1}; % We added only one DTC
            new_dtc_blkname = [obj.hobj.parent '/' ret.n_blk]; 
            
            new_delay = obj.mutant.add_block_before_block(new_dtc_blkname,...
                'simulink/Discrete/Delay',...
                struct(...
                    'InitialCondition', num2str(minVal)  ...
                )); %#ok<NASGU>
        end
        
        function [cond, oblk, oport, minVal] = get_sigrange(obj)
            cond = 'true';
            minVal = 0; % Just to init. 
            
            tmp = obj.hobj.if_cond_gen_blk{1};
            
            oblk = tmp{1, 'fullname'};
            [~, oblk] = utility.strip_last_split(oblk{1}, '/');
            
            sr = tmp{1, 'sigRange'};
            sr = sr{1};
            
            for oport = 1 : numel(sr)
                sr_i = sr{oport};
                minval = sr_i{1};
                
                if isempty(minval)
                    continue;
                end
                
                if isnumeric(minval)
                    obj.is_minrange_inf = isinf(minval);
                    if isscalar(minval)
                        cond = sprintf('%d <= u1', minval);
                        minVal = minval;
                    end
                end
                
                break;
                
            end
        end
        
    end
end

