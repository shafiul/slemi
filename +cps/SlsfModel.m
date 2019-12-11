classdef SlsfModel < cps.Model
    %SLSFMODEL Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        
    end
    
    methods
        
        function obj = SlsfModel (varargin)
            obj = obj@cps.Model(varargin{:});
        end
        
        function copy_from(obj, src)
            %% Create self copying from `src`
            try
                cps.top(false, @save_system,...
                    {src, [obj.loc filesep obj.sys]},...
                    obj.rec, 'Copying model from original');
            catch e
                utility.print_error(e, obj.l);
                obj.l.error('Could not write file probably because a model with same name is open. Closing it.');
                obj.close_model();
                rethrow(e);
            end
        end
        
        function load_model(obj)
            %%
            emi.open_or_load_model(obj.sys);
        end
        
        function ret = add_block_before_block(obj, blkname,blk_type, blk_config )
            [~,sources,~] = emi.slsf.get_connections(blkname, true, false);
            self_as_destination = emi.slsf.create_port_connectivity_data(blkname, size(sources, 1), 0);
            ret = obj.add_before_block(blkname, sources, self_as_destination, blk_type, blk_config);
        end
        
        function ret= add_before_block(obj, blkname, sources, self_as_destination, blk_type, blk_config)
            %% Adds a block before ALL input ports
            % sources contains all predecessors of `blkname`
            % self_as_destination is a crafted port-connectivity data
            % structure which contains the `blkname` block itself as
            % destination. Since we need to put DTC as predecessor -> DTC
            % -> blkname
            
            %varargin{1} could be a function handler to config the newly
            %added block. See add_DTC_in_middle for example
            
            ret = true; 
            
            if isempty(sources)
                return;
            end
            
            [parent, this_block] = utility.strip_last_split(blkname, '/');
            
            emi.slsf.delete_src_to_block(parent, this_block, sources);
            
            function ret = helper(blk_config_params, blk_out_type) %#ok<INUSD>
                ret = blk_config;
            end
            
            ret = obj.add_block_in_middle(sources, self_as_destination, parent,...
                blk_type, @helper);
        end
        
        function ret= add_DTC_before_block(obj, blkname, sources, self_as_destination)
            %% Adds a DTC block before ALL input ports
            % sources contains all predecessors of `blkname`
            % self_as_destination is a crafted port-connectivity data
            % structure which contains the `blkname` block itself as
            % destination. Since we need to put DTC as predecessor -> DTC
            % -> blkname
            
            ret = true; % for cellfun WARNING Now we return output of the called functions
            % May break some parts where this function is used in cellfun
            % change UniformOutput to false in the caller if this breaks other code.
            
            if isempty(sources)
                return;
            end
            
            [parent, this_block] = utility.strip_last_split(blkname, '/');
            
            emi.slsf.delete_src_to_block(parent, this_block, sources);
            
            ret = obj.add_DTC_in_middle(sources, self_as_destination, parent);
        end
        
        
        function ret = add_DTC_in_middle(obj, sources, dests, parent_sys)
            blk_type = 'simulink/Signal Attributes/Data Type Conversion';
            
            function ret = helper(blk_config_params, blk_out_type)
                ret = blk_config_params;
                
                if ~isempty(blk_out_type)
                    ret.OutDataTypeStr = emi.slsf.get_datatype(...
                        blk_out_type);
                end
            end
            
            ret = obj.add_block_in_middle(sources, dests, parent_sys,...
                blk_type, @helper);
        end
        
        function ret = add_block_in_middle(obj, sources, dests, parent_sys,...
                blk_type, fun)
            %% Adds a block between each source -> dest connection
            % Will specify the newly added block's type in the compiled
            % type registry.
            % Will call `fun` to configure the block if provided as
            % parameter.
            % Returns all newly added blocks along with it's predecessor
            % and successor. See emi.decs.DeleteDeadAddSaturation for an
            % example usage
                        
            combs = emi.slsf.choose_source_dest_pairs_for_reconnection(sources, dests);
            ret = cell(combs.len, 1);
            
            for i=1:combs.len
                cur = combs.get(i);
                
                n_blk_params = struct;
                
                % Specify the block's data type in compiled types registry
                if emi.cfg.SPECIFY_NEW_BLOCK_DATATYPE
                    n_blk_out_type = obj.get_compiled_type(parent_sys, cur.d_blk, 'Inport', cur.d_prt);
                else
                    n_blk_out_type = [];
                end
                
                if nargin > 5
                    n_blk_params = fun(n_blk_params, n_blk_out_type);
                end
                
                [new_blk_name, h] = obj.add_new_block_in_model(parent_sys, blk_type,...
                    n_blk_params);

                % add new block in compiled data types registry
                obj.add_block_compiled_types(parent_sys,...
                    cur.s_blk, cur.s_prt, new_blk_name, n_blk_out_type);

                % Connect n_blk -> destination
                obj.add_line(parent_sys, [new_blk_name '/1'],...
                    [cur.d_blk '/' int2str(cur.d_prt)]);
                
                % Connect source -> n_blk
                obj.add_line(parent_sys, [cur.s_blk '/'...
                        int2str(cur.s_prt)], [new_blk_name '/1' ]);
                    
                % Add new blk and the handle
                cur.n_blk = new_blk_name;
                cur.n_h = h;
                    
                ret{i} = cur;
            end
            
        end
        
        function [new_blk_name, h] = add_new_block_in_model(obj, parent, new_blk_type, varargin)
            %% varargin{1} : struct containing block config params
            % varargin{2} : if not empty then represents input output
            % types. Cell. Members: in_type, out_type, add_to_registry, specifyOut
            
            if nargin < 4
                blk_params = struct;
            else
                blk_params = varargin{1};
            end
            
            if nargin < 5
                in_out_types = [];
            else
                in_out_types = varargin{2};
            end
            
            
            new_blk_name = obj.get_new_block_name();
            
            n_blk_full = [parent '/' new_blk_name];
            
            h = obj.add_block(new_blk_type, n_blk_full,...
                obj.get_pos_for_next_block(parent));
            
            % Configure block params
            blk_param_names = fieldnames(blk_params);
            
            for i=1:numel(blk_param_names)
                p = blk_param_names{i};
                obj.set_param(h, p, blk_params.(p));
            end
            
            % Add compiled type
            
            if ~ isempty(in_out_types)
                obj.compiled_reg(parent, new_blk_name, in_out_types{:});
            end
            
            obj.l.debug('Added new %s block %s', new_blk_type, n_blk_full);
        end

        
        function [src_block, h] = copy_block(obj, src_parent, src_block, dest_parent, varargin)
            %%
            
            if nargin == 4
                blk_params = struct;
            else
                blk_params = varargin{1};
            end
            
            n_blk_full = [dest_parent '/' src_block];
            
            h = obj.add_block([src_parent '/' src_block], n_blk_full,...
                obj.get_pos_for_next_block(dest_parent));
            
            % Configure block params
            blk_param_names = fieldnames(blk_params);
            
            for i=1:numel(blk_param_names)
                p = blk_param_names{i};
                obj.set_param(h, p, blk_params.(p));
            end
            
            obj.l.debug('Block copied %s from %s to %s', src_block, src_parent, dest_parent);
        end
        
        function replace_block(obj, parent, blk, srcs, dests, is_if, replacement)
            %% Replace block 
            
            % Delete and replace old Connections
            obj.delete_src_to_block(parent, blk, srcs, replacement);
            obj.delete_block_to_dest(parent, blk, dests, is_if, replacement);
            
            obj.delete_block([parent '/' blk]);
        end
        
        function ret = get_root_sources(obj)
            % Get root-level source blocks
            sources = obj.blocks(cps.slsf.filter_source_blocks(obj.blocks), :);
            ret = sources{cps.slsf.unspecified_st(sources), 'fullname'};
        end
        
        function ret = get_model_builder(obj, parent)
            %% Create new or get existing ModelBuilder
            if obj.model_builders.isKey(parent)
                ret = obj.model_builders(parent);
            else
                ret = emi.slsf.ModelBuilder(parent);
                ret.init();
                obj.model_builders(parent) = ret;
            end
        end
        
        function ret = get_pos_for_next_block(obj, parent)
            %% Geometric position for this block in the model
            ret = obj.get_model_builder(parent).get_new_block_position();
        end

        
        %% Wrappers to Simulink APIs
        
        function h = add_block(obj, new_blk_type, new_blk_name, pos) %#ok<INUSL>
            h = add_block(new_blk_type, new_blk_name, 'Position', pos);
        end
        
        function delete_src_to_block(obj, block_parent, this_block, sources, varargin) %#ok<INUSL>
            emi.slsf.delete_src_to_block(block_parent, this_block, sources, varargin{:});
        end
        
        function delete_block_to_dest(obj, block_parent, this_block, destinations, is_if_block, varargin)  %#ok<INUSL>
            emi.slsf.delete_block_to_dest(block_parent, this_block, destinations, is_if_block, varargin{:});
        end
        
        function delete_block(obj, blk)  %#ok<INUSL>
            delete_block(blk);
        end
        
        function delete_line(obj, parent, src, dst) %#ok<INUSL>
            delete_line(parent, src, dst);
        end
        
        
        function ret = add_conn(obj, parent, sb, sp, db, dp)
            %% Adds connection from sb/sp --> db/dp 
            % sp or dp can be str or ints. 
            % sb can be handle or block without the parent part.
            
            if isnumeric(sb)
                [~, sb] = cps.slsf.h2b(sb);
            end
            
            if isnumeric(db)
                [~, db] = cps.slsf.h2b(db);
            end
            
            if isnumeric(sp)
                sp = int2str(sp);
            end
            
            if isnumeric(dp)
                dp = int2str(dp);
            end
            
            ret = obj.add_line(parent, [sb '/' sp], [db '/' dp]);
        end
        
        function ret = add_line(obj, this_sys, src, dest)
            %% May want to use `add_conn` as higher level function
            ret = 1; %dummy
            add_line(this_sys, src, dest, 'autorouting','on');
            
            obj.l.debug('[X-->Y] In %s, connected %s ---> %s',...
                this_sys, src, dest);
        end
        
        function ret = get_block_type(obj, blk)
            ret = get_param([obj.sys '/' blk], 'BlockType');
        end
        
        function e = fixate_sample_time(obj, blk)
            % TODO uses sample time "1" as SLforge-generated models may
            % have this rate. Will not work for models in general where
            % there are some other rate/multiple rates
            f_blk = [obj.sys '/' blk];
            e = obj.set_param(f_blk, 'SampleTime', '1', true);
            if ~ isempty(e)
                e = obj.set_param(f_blk, 'tsamp', '1', true);
            end
        end
        
        function e = set_param(~, slob, k, v, use_try_catch)
            %% Safely try setting a parameter through Simulink APIs
            % When we are not sure whether setting will throw, use
            % use_try_catch = true
            
            e = [];
            
            if nargin == 4
                use_try_catch = false;
            end
            
            do_log = true; %#ok<NASGU>
            
            if use_try_catch
                try
                    set_param(slob, k, v);
                catch e
                    do_log = false; %#ok<NASGU> strcmp(e.identifier, 'SimulinkBlock:Foundation:UdtInvalidValue') == 1
                end
                return;
            else
                set_param(slob, k, v);
            end
            
            % log
            
        end
        
        function close_model(obj)
            %% Saves self and closes
            save_system(obj.sys);
            
            if ~ emi.cfg.INTERACTIVE_MODE
                bdclose(obj.sys);
            end
            
            % Close newly generated ones
            obj.modelrefs.map(@emi.close_models);
        end
    end
    
    
%     cps.top(false, @,...
%                 {},...
%                 '');
end

