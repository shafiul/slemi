function  pause_interactive( varargin )
%PAUSE_INTERACTIVE Summary of this function goes here
%   varargin{1}, if boolean, denotes "Force Pause"

is_pause = emi.cfg.INTERACTIVE_MODE;

if nargin > 1 && islogical(varargin{1})
    is_pause = is_pause || varargin{1};
    string_starts_at = 2;
else
    string_starts_at = 1;
end

if is_pause
    if nargin >= string_starts_at
        varargin{string_starts_at} = [varargin{string_starts_at} '\n'];
        fprintf(sprintf(varargin{string_starts_at:end}));
    end
    
    fprintf('[[^***^]] Pausing due to interactive mode...\n');
    pause;
end

end

