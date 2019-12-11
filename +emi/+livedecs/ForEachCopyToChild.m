classdef ForEachCopyToChild  < emi.livedecs.CopyToChild
    % Copies a block to be mutated to a child model
    %   Also deletes the block to be mutated 
    
    
    methods
        function obj = ForEachCopyToChild(varargin)
            %COPYTOCHILD Construct an instance of this class
            obj = obj@emi.livedecs.CopyToChild(varargin{:});
        end
        
        
        function config_foreach(obj, new_inports)
            
            if isempty(new_inports)
                return;
            end
            
            foreach_fullpath = [obj.hobj.parent '/' obj.hobj.new_ss '/For Each'];
            t = arrayfun(@(p)'On', 1:numel(new_inports), 'UniformOutput', false);
    
            try
                set_param(foreach_fullpath, 'InputPartition', t);
            catch e
                disp(e);
            end
        end

        
        function go(obj, varargin)
            %METHOD1 Summary of this method goes here
            new_ss_fullpath = [obj.hobj.parent '/' obj.hobj.new_ss];
            
            new_inports = obj.copy_to_path(new_ss_fullpath);
            
            obj.config_foreach(new_inports);
        
            obj.replace_old(new_ss_fullpath);   
        end
    end
end

