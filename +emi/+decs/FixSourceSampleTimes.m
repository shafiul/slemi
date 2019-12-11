classdef FixSourceSampleTimes < emi.decs.DecoratedMutator
    %FIXSOURCESAMPLETIMES Fixate root level unspecified source block STs.
    %   Only fix those who offers the SampleTime or tsamp parameter.
    
    methods
        
        function obj = FixSourceSampleTimes (varargin)
            obj = obj@emi.decs.DecoratedMutator(varargin{:});
        end
        
        function preprocess_phase(obj)
            
            function ret = helper(blk)
                ret = isempty(obj.mutant.fixate_sample_time(blk));
            end
            
            assert(all(cellfun(@helper,...
                obj.mutant.get_root_sources())));
            
        end
    end
end

