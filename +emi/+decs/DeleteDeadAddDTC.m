classdef DeleteDeadAddDTC < emi.decs.DeadBlockDeleteStrategy
    %DELETEDEADADDDTC After Deleting a block add a DTC
    %   Used this strategy before implementing pre-processing. Since we
    %   have to pre-process anyway to prevent data-type back-prop, this
    %   strategy is not used to promote direct-connection 

    
    methods
        
        function obj = DeleteDeadAddDTC (varargin)
            obj = obj@emi.decs.DeadBlockDeleteStrategy(varargin{:});
        end
        
        function post_delete_strategy(obj, sources, dests, parent_sys)
            obj.mutant.add_DTC_in_middle(sources, dests, parent_sys);
        end
    end
end

