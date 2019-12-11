function ret = rowfun_eh( S, varargin )
%ROWFUN_EH Summary of this function goes here
%   Detailed explanation goes here
warning('Error handler at %d index.\nID: %s\nMessage: %s', S.index, S.identifier, S.message);
disp(varargin{:});
ret = NaN;
end

