function [ models ] = merge_reports(date_from, varargin )
%MERGE_REPORTS Summary of this function goes here
%   varargin{1} is subdirectory to look for.

covexp.addpaths();

date_from = strsplit(date_from, '_');
date_from = date_from{1};

l = logging.getLogger('mergereports');

report_dir = [covcfg.RESULT_DIR_COVEXP filesep covexp.get_subdir(varargin{:})];

individual_results = utility.batch_process(report_dir, 'covexp_result', {...
    {@utility.date_filter, date_from, covcfg.DATETIME_STR_TO_DATE, {'_', '.mat'}}...
}, @filter_data);

models = individual_results{1};

for i=2:numel(individual_results)
    models = [models individual_results{i}]; %#ok<AGROW>
end

nowtime_str = datestr(now, covcfg.DATETIME_DATE_TO_STR);

dest_file = [covcfg.RESULT_DIR_COVEXP filesep nowtime_str '_merged'];

covexp_result = struct('models', models); %#ok<NASGU>

save(dest_file, 'covexp_result');

end

function ret = filter_data(data)

ret = data.models;

% add missing fields

report_ds = covexp.get_report_datatype();
report_ds_fields = fieldnames(report_ds);

for i=1:numel(report_ds_fields)
    f = report_ds_fields{i};
    
    if ~ isfield(ret, f)
        ret(1).(f) = [];
    end
end

end

