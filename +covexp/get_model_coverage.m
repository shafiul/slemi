function [all_blocks, num_zero_cov] = get_model_coverage(h, reduce_blocks)
%GET_MODEL_COVERAGE Summary of this function goes here
%   WARNING -- If you add new data here (e.g. to `blocks`, you would need
%   to rerun experiment # 2,3, and 8. So probably exp#8 is a better place
%   to add new stuff.

if nargin == 1
    reduce_blocks = false;
end

% Dynamic Signal Range analysis
% https://www.mathworks.com/help/slcoverage/ref/sigrangeinfo.html
DO_SIGNAL_RANGE = true;

num_zero_cov = 0; % blocks with zero coverage

testObj  = cvtest(h);

if DO_SIGNAL_RANGE
    %Enable signal range coverage
    testObj.settings.sigrange = 1;
end

if reduce_blocks
    warning('Setting CovForceBlockReductionOff=off')
    data = cvsim(testObj, 'CovForceBlockReductionOff', 'off');
else
    % Note: this just disables the force-off. Behavior will now depend on
    % the model's 'BlockReduction' parameter. What if is is set to 'off'?
    % Default is 'on'
    data = cvsim(testObj);
end

blocks = covexp.get_all_blocks(h);

all_blocks = struct;

for i=1:numel(blocks)
    cur_blk = blocks(i);

    cur_blk_name = getfullname(cur_blk);

    cov = executioninfo(data, cur_blk);
    percent_cov = [];

    if ~ isempty(cov)
        percent_cov = 100 * cov(1) / cov(2);

        if percent_cov == 0
            num_zero_cov = num_zero_cov + 1;
        end
    end
    
    sigRange = {};
    usable_sigRange = false; % Can use this signal range to synthesize conditions
    
    if DO_SIGNAL_RANGE && cur_blk ~= h % Not Root-level model
        
        try
            [~, ~, dsts] = emi.slsf.get_connections(cur_blk, false, true);
            n_dsts = size(dsts, 1);
            
            tmp = utility.cell(n_dsts);
            
            for d=1:n_dsts
                [minVal, maxVal] = sigrangeinfo(data, cur_blk, d);
%                 if isinf(minVal)
%                     disp('inf');
%                 end
                tmp.add({minVal, maxVal});
                
                if ~usable_sigRange && (~isempty(minVal))
                    usable_sigRange = true;
                end
            end
            
            sigRange = tmp.get_cell();
        catch e
            utility.print_error(e);
            rethrow(e);
        end
        
%         
%         if ~isempty(minVal) || ~isempty(maxVal)
%         
%         end
    end


    all_blocks(i).fullname = cur_blk_name;
    all_blocks(i).percentcov = percent_cov;
    
    all_blocks(i).sigRange = sigRange;
    all_blocks(i).usable_sigRange = usable_sigRange;
%     all_blocks(i).maxVal = maxVal;

    try
        all_blocks(i).blocktype = get_param(cur_blk, 'blocktype');
    catch
        all_blocks(i).blocktype = [];
    end
end


end

