function [ ret ] = batch_process( report_dir, variable_name, filename_filters, data_filter, varargin)
%BATCH_PROCESS Explores `report_dir` using utility.dir_process
%   Loads a single variable `variable_name` from each of the files, if the
%   parameter is not empty.
% Applies data_filter to the loaded variable.
% Returns concatenated result
% Pass a system-level filename suffix as 5th argument. This suffix would be
% passed to the system-level command to list files. If you'd like to
% explore subdirectories for all files named `reports.mat`, pass empty
% string here and use {{@(p, ~)strcmp(p, 'reports.mat'), {}}} as filename
% filter -- which is a cell of filters. Each cell is a two-element cell,
% the first element is a lambda and second element is arguments to this
% lambda function.

filename_suffix = '*.mat';
explore_subdirs = false;
uniform_output = false;

if nargin >= 5
    filename_suffix = varargin{1};
end

if nargin >= 6
    explore_subdirs = varargin{2};
end

if nargin >= 7
    uniform_output = varargin{3};
end

function load_result = load_from_each_file(cur_file, cur_dir)
    try
        load_result = load([cur_dir filesep cur_file]);
        
        if ~ isempty(variable_name)
            load_result = load_result.(variable_name);
        end
    catch
        % Corrupt data. It's up to `data_filter` to decide what to do now.
        load_result = [];
    end
   
    
    if ~ isempty(data_filter)
        load_result = data_filter(load_result);
    end
end

files = utility.dir_process(report_dir, filename_suffix, explore_subdirs, filename_filters);

fprintf('batch_process found %d filtered files before data loading.\n', length(files));

ret = cellfun(@load_from_each_file, files(:, 1), files(:,2), 'UniformOutput', uniform_output);

end


