classdef CopyToModel  < emi.livedecs.CopyToChild
    %COPYTOCHILD Copies a block to be mutated to a child model
    %   Also deletes the block to be mutated 
    
    
    methods
        function obj = CopyToModel(varargin)
            %COPYTOCHILD Construct an instance of this class
            obj = obj@emi.livedecs.CopyToChild(varargin{:});
        end
        
        function go(obj, varargin)
            %METHOD1 Summary of this method goes here
            new_ss_fullpath = [obj.hobj.parent '/' obj.hobj.new_ss];
            
            new_inports = obj.copy_to_path(obj.hobj.model_name);
            
            obj.mutant.assign_pred_types(...
                obj.hobj.model_name, new_inports, obj.hobj.sources,...
                false, true); % don't add to compiled registry, specify type
            
            
            % Save the model
            save_system(obj.hobj.model_name, [obj.mutant.loc filesep obj.hobj.model_name])
            
            obj.mutant.set_param(new_ss_fullpath, 'ModelFile', obj.hobj.model_name);

            obj.replace_old(new_ss_fullpath);

        end
    end
end

