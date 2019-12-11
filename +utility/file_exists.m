function result = file_exists(parent_dir,varargin)
%FILE_EXISTS usage: file_exists(fullpath) or file_exists(dir, file)
%   Detailed explanation goes here

if nargin == 2
    parent_dir = [parent_dir filesep varargin{1}];
end

% result = isfile(parent_dir); % Doesn't work in 2017a

result = exist(parent_dir, 'file') > 0;

end

