function ret = fix_input_loc(~, ~, ret)
%FIX_INPUT_LOC Fixes `input_loc` automatically
%   No need to do anything, input_loc is already fixed by 
% `covexp.check_model_opens`. We just need to set FORCE_UPDATE true such
% that this updated data gets written.

%% Do some other rectification

for i=1:numel(covcfg.EXP5_FIELDS_TO_DEL)
    if isfield(ret, covcfg.EXP5_FIELDS_TO_DEL{i})
        ret = rmfield(ret, covcfg.EXP5_FIELDS_TO_DEL{i});
    end
end

end

