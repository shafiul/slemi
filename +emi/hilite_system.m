function hilite_system( sys, varargin )
%HILITE_SYSTEM Summary of this function goes here
%   varargin{1} is boolean, whether to force enable higliting. If not
%   passed, then we hilite only in interactive mode.

style = 'default';
is_hilite = emi.cfg.INTERACTIVE_MODE;
    
if nargin == 2
    is_hilite = is_hilite || varargin{1};
end

if nargin == 3
    style = varargin{2};
end

if ~ is_hilite
    return;
end

if ~iscell(sys)
    sys = {sys};
end

cellfun(@(p)hilite_system_wrapper(p, style), sys);

end

function [ ret ] = hilite_system_wrapper( sys, style )
%HILITE_SYSTEM Summary of this function goes here
%   Detailed explanation goes here
hilite_system(sys, style);
ret = true;
end

