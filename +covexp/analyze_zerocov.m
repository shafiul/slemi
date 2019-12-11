function [ models, blktypes ] = analyze_zerocov(  )
%ANALYZE_ZEROCOV 
%   Detailed explanation goes here
S = load(covcfg.RESULT_FILE);
covexp_result = S.covexp_result;

models = struct2table(covexp_result.models);
models = models(:,{'m_id', 'sys', 'blocks', 'numzerocov'});

    function ret = filter_models(~, ~, ~, numzerocov)
        ret = ~isempty(numzerocov{1}) && numzerocov{1} > 0;
    end

zero_models = rowfun(@filter_models, models, 'OutputFormat', 'uniform');
models = models(zero_models, :);

    function ret = filter_blocks(~, ~, blocks, ~)
        blocks = struct2table(blocks{1});
        filter_res = rowfun(@(~, cov, bltype) ~isempty(cov{1}) && cov{1} < 100, blocks, 'OutputFormat', 'uniform');
        ret = blocks(filter_res, :);
    end

blktypes = rowfun(@filter_blocks,  models, 'OutputFormat', 'cell');

end

