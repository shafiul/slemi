function ret = close_models(models)
%CLOSE_MODELS Summary of this function goes here
%   Detailed explanation goes here

ret = true;

if ~iscell(models)
    models = {models};
end

    function ret = inner(m)
        ret = true;
        bdclose(m);
    end

cellfun(@inner, models);

end

