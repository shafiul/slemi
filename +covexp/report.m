function [ models, comp_e_dts, b4_e_dts ] = report( varargin )
%REPORT Generate reports for covcollect
%   varargin{1}: file to load for report
% varargin{2} additional functions to call with the `covexp_results`
% argument.
covexp.addpaths();

l = logging.getLogger('report');

if nargin < 1
    result_file = covcfg.RESULT_FILE;
else
    result_file = [covcfg.RESULT_DIR_COVEXP filesep varargin{1}];
end

tmp = load(result_file); 
covexp_result = tmp.covexp_result;

models = covexp_result.models;

% General stats

utility.tabulate('opens', models, 'Does Model Open?', l);

utility.tabulate('compiles', models, 'Does Model Compile?', l);

% Timeout should now appear as exception. The previously reported boolean
% field should now be meaningless to report.
% utility.tabulate('timedout', models, 'Does Model time-out?', l);

utility.tabulate('exception', models, 'Does Model error?', l);

utility.tabulate('peprocess_skipped', models, 'Preprocess: skipped?', l);
utility.tabulate('preprocess_error', models, 'Preprocess: error?', l);

[models, comp_e_dts, b4_e_dts ] = covexp.experiments.reports.do_difftest(models, l);

% Number of zero blocks

if ~ isfield(models, 'numzerocov')
    return;
end

numzero = [models.numzerocov];

if ~isempty(numzero)
    % Remove the empty cells from `{models.blocks}`
    model_blocks = {models.blocks};
    model_blocks = model_blocks(cellfun(@(p)~isempty(p), model_blocks));

    total_blocks = arrayfun(@(p)numel(p{1}) - 1, model_blocks);
    
    numzero_ratio = arrayfun(@(p,q) p/q*100.0, numzero, total_blocks);
    l.info('Mean dead block percentage: %f; median: %f', mean(numzero_ratio), median(numzero_ratio));
    
    boxplot(numzero_ratio);
    title('Total blocks with no coverage / number of blocks');

else
    l.info('No dead blocks!!!');
end

l.info('Does model has at least one block with no cov?');
haszero = arrayfun(@(p)p>0, numzero);
tabulate(haszero);

% difftest_runtime(models);

end


% function difftest_runtime (models)
%     durations = {'simdur', 'duration', 'compile_dur', 'avg_mut_dur'};
% end
