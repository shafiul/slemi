function error( varargin )
%FATAL log the error and end script.
%   Detailed explanation goes here
l = varargin{1};
l.critical(varargin{2:end});
error('FATAL ERROR!');
end

