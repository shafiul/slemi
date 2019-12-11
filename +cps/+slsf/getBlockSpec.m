function all_data = getBlockSpec(libnames, force_update)
%GETBLOCKSPEC Get interesting properties/values from built-in blocks
%   getBlockSpec({'Sources', 'Sinks', 'Discrete', 'Ports & Subsystems'}, true)

load_system('simulink');

sys = 'getBlockSpecSys';

if nargin == 1
    force_update = false;
end

if ~ iscell(libnames)
    libnames = {libnames};
end

new_system(sys);
open_system(sys);

e = [];

try
    all_data = get_data(sys, libnames, force_update);
catch e
    utility.print_error(e);
end

bdclose(sys);

if ~ isempty(e)
    rethrow(e);
end

end

function ret = get_error_str(b)
    % Blocks show a possibly unique name when showing any error. Probably
    % this can proxy as unique block-type identifier?
    try
        get_param(b, 'cyemi'); %non-existing parameter
    catch e
        err_msg = e.message;
    end
    
    ret = err_msg(1:strfind(err_msg, ' block does not')-1);
end

function ret = field_set_errors(b, fld, val)
    ret = false;
    try
        set_param(b, fld, val);
    catch 
        ret = true;
    end
end


function ret = get_data(sys, libnames, force_update)

data_file = 'GetBlockSpecCached';

if ~ force_update
   ret = load(data_file);
   ret = ret.ret;
   return;
end

ret = utility.cell();

for i = 1:numel(libnames)
    libn = libnames{i};
    blocks = utility.getBlocksOfLibrary(libn);

    for j=2:numel(blocks)
        blk = blocks{j};

        try
            h = add_block(blk, [sys '/b' int2str(ret.len)] ,'MakeNameUnique','on');
        catch f
            % Block not allowed in root level. Does that mean we should try
            % out putting inside a subsystem? At the very least inspect
            % them manually, so displaying the error.
            fprintf('Inspect me manually:\n');
            utility.print_error(f);
            continue;
        end

        % Num out ports
        portHs = get_param(h, 'PortHandles');
        n_outports = numel(portHs.Outport);
        n_inports = numel(portHs.Inport);

        % OutDataTypeStr

        ob_params = cps.slsf.block_parameters(h);

        is_odts = isfield(ob_params, 'OutDataTypeStr');

        % Block Type
        blktype = get_param(h, 'BlockType');

        refblock = get_param(h, 'ReferenceBlock');
        mask_type = get_param(h, 'MaskType');
        err_label = get_error_str(h);
        
        % sample time
        obparams = get_param(h, 'ObjectParameters');
        
        st_errors = field_set_errors(h, 'SampleTime', '-1');
        st_hasfield = isfield(obparams, 'SampleTime');
        
        tsamp_errors = field_set_errors(h, 'tsamp', '-1');
        tsamp_hasfield = isfield(obparams, 'tsamp');
        % Save data
        
        ret.extend({libn, blk, blktype, n_outports, n_inports,...
            is_odts, ob_params,...
            refblock, mask_type, err_label, st_errors, st_hasfield,...
            tsamp_errors, tsamp_hasfield});
        
    end
end

var_names = {'Lib', 'Block', 'BlockType', 'nOutports', 'nInports',...
    'OutDataTypeStr',...
    'Params', 'ReferenceBlock', 'MaskType', 'ErrorLabel',...
    'STerrors', 'SThas', 'tsampErrors', 'tasampHas'};
n_cols = length(var_names);

ret = cell2table(ret.get_cell2D([], n_cols));
ret.Properties.VariableNames = var_names;

fprintf('Caching...\n');
save(data_file, 'ret');

end

