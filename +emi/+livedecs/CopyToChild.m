classdef CopyToChild  < emi.livedecs.Decorator
    %COPYTOCHILD Copies a block to be mutated to a child model
    %   Also deletes the block to be mutated 
    
    
    methods
        function obj = CopyToChild(varargin)
            %COPYTOCHILD Construct an instance of this class
            obj = obj@emi.livedecs.Decorator(varargin{:});
        end
        
        function new_inputs = copy_to_path(obj, dstpath)
            % 
            target_inport_sz = size(obj.hobj.sources, 1);
            target_outport_sz = size(obj.hobj.destinations, 1);
            
            % create new inports
            new_inputs = arrayfun( @(~)...
                obj.mutant.add_new_block_in_model(...
                dstpath, 'simulink/Sources/In1'...
                ), 1:target_inport_sz, 'UniformOutput', false...
            );
            
            % copy the block to be mutated into the new child model
            obj.mutant.copy_block(obj.hobj.parent, obj.hobj.blk,...
                dstpath);
            
            % create new outports
            new_outputs = arrayfun( @(~)...
                obj.mutant.add_new_block_in_model(...
                dstpath, 'simulink/Sinks/Out1'...
                ), 1:target_outport_sz, 'UniformOutput', false...
            );
        
            % Reconnect inside new child
            
            % new_inputs --> copied_block
            if ~isempty(new_inputs)
                cellfun(...
                            @(bl, prt)obj.mutant.add_line(dstpath, [bl '/1'],...
                            [obj.hobj.blk '/' int2str(prt)])...
                        , new_inputs, num2cell(1:target_inport_sz ));
            end
            
            % copied_block --> new outputs
            if ~isempty(new_outputs)
                cellfun(...
                            @(bl, prt)obj.mutant.add_line(dstpath,...
                            [obj.hobj.blk '/' int2str(prt)], [bl '/1']) ...
                        , new_outputs, num2cell(1:target_outport_sz) );
            end

        end
        
        function replace_old(obj, dest)
            % Reconnect outside new child i.e. inside obj.hobj.parent
            
            obj.mutant.replace_block(obj.hobj.parent, obj.hobj.blk, obj.hobj.sources,...
                obj.hobj.destinations, obj.hobj.is_if_block, obj.hobj.new_ss);
            
            % Rename the newly added SS so that we can use if in
            % differential testing
            

            obj.mutant.set_param(dest, 'Name', obj.hobj.blk);
        end
        
        function go(obj, varargin)
            %METHOD1 Summary of this method goes here
            new_ss_fullpath = [obj.hobj.parent '/' obj.hobj.new_ss];
            
            obj.copy_to_path(new_ss_fullpath);
        
            obj.replace_old(new_ss_fullpath);   
        end
    end
end

