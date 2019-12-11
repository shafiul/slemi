function [ ret ] = dir_process( base_dir, filename_suffix, explore_subdirs,...
    filename_filters, isdir_check, dir_blacklist )
%DIR_PROCESS Explores all files from `base_dir` which have suffix
%`filename_suffix`. Then filters these filenames using `filename_filters`.
%Will recursively process sub-directories if `explore_subdirs` is true.
%`filename_filters` is a cell array of 1X2cell arrays, each of which is a 
%filter. First element is function name and second element is a cell whose
% elements are arguments to that function. However, first argument of a 
% filter is always the filename. See `utility.date_filter` function for an
% example.
% Returns a cell array with two columns, first column is the filename and 
% second column contains directory name.
% If isdir_check = false (default), will skip directories. If true, skip
% files and only include directories.
% Any directory name in `dir_blacklist` would not be further explored for
% files/subdirectories.

if nargin < 5
    % Files Only
    isdir_check = false;
end

if nargin < 6
    dir_blacklist = {};
end

fields_to_return = {'name', 'folder'};
base_dir_filter = @(dirname) ~strcmp(dirname, '.') && ~strcmp(dirname, '..');

files = dir([base_dir filesep filename_suffix]);

files = struct2table(files);
files = files(:, [ fields_to_return {'isdir'} ]);

% Handle files

actual_file_result = rowfun(@(p, ~, isdir) base_dir_filter(p) && isdir == isdir_check, files,...
    'OutputFormat', 'uniform');

actual_files = files(actual_file_result, fields_to_return);

ret = table2cell(actual_files);

% Apply filters to filename
if ~ isempty(filename_filters)
    ret = ret(...
                cellfun(...
                    @(p) all(...
                                    cellfun(...
                                                @(x)x{1}(p, x{2:end})...
                                    ,filename_filters)...
                                )...
                , ret(:, 1))...
            , : );
end

if ~ explore_subdirs
    return;
end

% Handle Directories

dir_result = rowfun(...
        @(name, ~, isdir) isdir && base_dir_filter(name) && ...
        ~any(strcmp(name, dir_blacklist)) ,...
    files, 'OutputFormat', 'uniform');
dirs_to_explore = files{dir_result, {'name'}};

if isempty(dirs_to_explore)
    return;
end

recursive_results = cellfun(...
            @(p) utility.dir_process([base_dir filesep p], filename_suffix,...
                            explore_subdirs, filename_filters, false,... % note: not passing original isdir_check -- may be a bug.
                            dir_blacklist)...
        , dirs_to_explore, 'UniformOutput', false );

recursive_results = vertcat(recursive_results{:});
% Concat results
if ~isempty(recursive_results)
    ret = vertcat(ret, recursive_results);
end

end

