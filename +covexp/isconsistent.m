function [ret, first, cur] = isconsistent( varargin )
%COVEXP_CON Check consistency of coverage experiments
%   Detailed explanation goes here
covexp.addpaths();

l = logging.getLogger('consistency');

ret = true; % success
first = []; % baseline experiment against which the comparisons are made
cur = []; % current comparison

subdir = '';
if nargin > 0
    subdir = [varargin{1} filesep '/' ];
end

report_base = [covcfg.RESULT_DIR_COVEXP filesep subdir];

file_list = dir([report_base '*.mat' ]);

all = utility.cell(10); % capacity

for i=1:numel(file_list)
    clear covexp_result;
    cur_file = file_list(i).name;
        
%     if file_list(i).isdir || strcmp(cur_file, '.') || strcmp(cur_file, '..')
%         continue;
%     end

    load([report_base filesep cur_file]);
    
    all.add(covexp_result);       

end

if all.len < 1
    l.info('No experiment files!');
    return;
end

first_w = all.get(1);
first = first_w.models;
first = delete_fields(first);

for i=1:all.len
    
    cur_w = all.get(i);
    cur = cur_w.models;
    
    cur = delete_fields(cur);
    
    if ~ isequal(first, cur)
        l.error(sprintf('Did not match: %d exp', i));
        ret = false;
        return;
    end
    
end

l.info('End of consistency check... no issues!');

end

function ret = delete_fields(p)
    ret = rmfield(p, 'duration');
    ret = rmfield(ret, 'simdur');
end