classdef TypeAnnotateByOutDTypeStr < emi.decs.DecoratedMutator
    %TYPEANNOTATEBYOUTDTYPESTR Tries to annotate out type through parameter
    %   Previously, we used to put a Data-Type Converter block after every
    %   block. However, this caused issue (TSC 03404633). E.g. an uint
    %   output type will eventually loss the full-precision double output.
    %   Here, we try to annotate output type by changing the parameter
    %   OutDataTypeStr. For the blocks this is not possible, we will store
    %   the block names in obj.r.non_outdtypes
    
    
    methods
        
        function obj = TypeAnnotateByOutDTypeStr (varargin)
            obj = obj@emi.decs.DecoratedMutator(varargin{:});
        end
        
        function preprocess_phase(obj)
            
            % Blocks which possibly do not support OutDataTypeStr
            error_blktypes = containers.Map();
            
            function ret = helper(blk)
                k = obj.mutant.get_block_type(blk);
                
                if error_blktypes.isKey(k)
                    ret = false;
                else
                    ret = cps.slsf.fixate_outtype_by_param(obj.mutant, blk);
                    
                    if ~ ret && ~ strcmp(k, 'SubSystem')
                        error_blktypes(k) = 1;
                    end
                end
            end
            
            cellfun(@helper,...
                obj.r.blocks_to_annotate);
            
        end
    end
end

