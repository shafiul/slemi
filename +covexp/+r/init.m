function [result, l] = init(varargin)
%INIT Load covexp result (and init logger) if necessary
%   Detailed explanation goes here

if numel(varargin) < 1
    result_file = covcfg.RESULT_FILE;
else
    result_file = [covcfg.RESULT_DIR_COVEXP filesep varargin{1}];
end

if numel(varargin) < 2
    l = logging.getLogger('report');
else
    l = varargin{2};
end


result = load(result_file);
result = result.covexp_result;
end

