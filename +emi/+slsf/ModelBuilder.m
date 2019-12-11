classdef ModelBuilder < handle
    %MODELBUILDER Manage drawing and model-building for Simulink/Stateflow
    %   Detailed explanation goes here
    
    properties
        
    end
    
    properties(Access=protected)
        sys;        
        
        % Drawing related
        d_x = 0;        % x coordiate of next block
        d_y = 0;        % y coordiate of next block
        c_block = 0;    % number of blocks
        
        % Block size
        width = 60;
        height = 60;
        
        % Position of the first block
        pos_x = 30;
        pos_y = 30;

        % Space between blocks
        hz_space = 100;
        vt_space = 150;

        % Number of blocks per line
        blk_in_line = 10;
        
    end
    
    methods
        function obj = ModelBuilder(sys)
            obj.sys = sys;
        end
        
        function init(obj)
            obj.init_drawing();
        end
        
        function pos = get_new_block_position(obj)
            obj.c_block = obj.c_block + 1;
            
            h_len = obj.d_x + obj.width;

            pos = [obj.d_x, obj.d_y, h_len, obj.d_y + obj.height];
            
            % Update x
            obj.d_x = h_len;

            % Update y
            if rem(obj.c_block, obj.blk_in_line) == 0
                obj.d_y = obj.d_y + obj.vt_space;
                obj.d_x = obj.pos_x;
            else
                obj.d_x = obj.d_x + obj.hz_space;
            end
        end
        
    end
    
    methods(Access=protected)
        
        
        function init_num_blocks(obj)
            obj.c_block = numel(emi.slsf.get_all_top_level_blocks(obj.sys));
        end
        
        function init_drawing(obj)
            obj.init_num_blocks();
            num_rows = obj.c_block/obj.blk_in_line + 1;
            
            obj.d_x = obj.pos_x;
            obj.d_y = obj.pos_y + num_rows * (obj.vt_space + obj.height);
        end
        
    end
end

