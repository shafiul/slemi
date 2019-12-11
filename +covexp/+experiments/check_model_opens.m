function [model_result, h] = check_model_opens(sys, model_id, model_path, model_result)
%CHECK_MODEL_OPENS Whenever you run covexp.covcollect, we run this script
%   The script runs when at least one other experiment is set to run and
%   FORCE UPDATE is set to true (otherwise no result will be saved in
%   disc). If saving the results, this script will update the model's
%   physical location (loc_input) which is essential if copying cached
%   results from some other machine.
h = [];

model_result.m_id = model_id;
model_result.sys = sys;

% If EXPLORE mode has been used, `model_path` points to the full path of
% the model in this machine.
model_result.loc_input = model_path;

model_result.sys_ext = []; % Model extension

model_result.skipped = false;
model_result.opens = false;

if covcfg.SOURCE_MODE == covexp.Sourcemode.CORPUS && ...
        isfield(covcfg.SKIP_LIST, sprintf('x%d', model_id))
    model_result.skipped = true;
    return;
end

% Does it open?

try
    h = load_system(sys);
    if covcfg.OPEN_MODELS
        open_system(sys);
    end
    
    model_result.opens = true;
    model_result.sys_ext = emi.slsf.get_extension(sys);
catch
%     ret.exception = true;
%     ret.exception_msg = e.identifier;
end

end

