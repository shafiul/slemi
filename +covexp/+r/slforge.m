function ret = slforge(slforge_reports_dir)
%SLFORGE Collect SLforge stats e.g. runtime
%   Detailed explanation goes here

addpath('slsf');

try
    if nargin < 1
        slforge_reports_dir = strjoin({'..', 'slsf_randgen', 'slsf', 'reportsneo'}, filesep);
    end


    disp(['Looking in dir: ' slforge_reports_dir]);
    
    tmp = utility.batch_process(slforge_reports_dir, [],... % variable name
            {{ @(p)strcmp(p, 'reports.mat')}}, @myfilter, '', true, true); %  subdirs; uniform output
    
    tmp = sum(tmp) / 3600;    
        
    ret = tmp;

catch e
    utility.print_error(e);
end

rmpath('slsf');


end

function ret = myfilter(data)

    ret = 0;

    if isempty(data) || ~ isfield(data, 'runtime')
        return;
    end
    
    rt = data.runtime;
    x = rt.get_cell();
    ret = sum(cellfun(@(p)sum(p), x));
    
end

