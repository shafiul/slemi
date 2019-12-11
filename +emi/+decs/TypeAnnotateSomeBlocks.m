classdef TypeAnnotateSomeBlocks < emi.decs.DecoratedMutator
    %TYPEANNOTATESOMEBLOCKS Summary of this class goes here
    %   WARNING Legacy decorator and have not been tested after refactoring
    
    methods
        
        function obj = TypeAnnotateSomeBlocks (varargin)
            obj = obj@emi.decs.DecoratedMutator(varargin{:});
        end
        
        function preprocess_phase(obj) 
            %% Filter blocks by type and then apply a function on that block
            configs = {...
                {'Delay', @preprocess_delay_blocks}... % Delay blocks only
                };
            for i=1:numel(configs)
                cur = configs{i};
                filter_fcn = cur{2};
                target_blocks = obj.mutant.filter_block_by_type(cur{1});
                cellfun(@(p)filter_fcn(obj, [obj.sys '/' p]),target_blocks);
            end
        end
        
        function ret = preprocess_delay_blocks(obj, blkname)
            %% Add DTC block at the 2nd/delay port of a Delay block
            [~,sources,~] = emi.slsf.get_connections(blkname, true, false);
            sources = sources(strcmp(sources.Type, '2'), :);
            % Destination is just one port: the 2nd port at a delay block
            self_as_destination = emi.slsf.create_port_connectivity_data(blkname, 1, 1);
            ret = obj.mutant.add_DTC_before_block(blkname,sources, self_as_destination);
        end
    end
end

