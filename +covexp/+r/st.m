function [pct_empty, pct_inherited] = st(varargin)
%ST Sample Time stats
%   Detailed explanation goes here
[result, l] = covexp.r.init(varargin{:}); %#ok<ASGLU>

blocks = {result.models.blocks};

    function [n_empty, n_inherited] = handle_model(blks)
        n_empty = sum(cellfun(@(p)isempty(p), {blks.st_param})) / length(blks);
        n_inherited = sum(cellfun(@(p)~isempty(p) && strcmp(p, '-1'), {blks.st_param})) / length(blks);
        
    end

[pct_empty, pct_inherited] = cellfun(@handle_model, blocks);


boxplot(pct_empty);
title('Percentage of blocks having no SampleTime parameter');

figure();

boxplot(pct_inherited);
title('Percentage of blocks having Inherited SampleTime parameter (-1)');

end

