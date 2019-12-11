function ret = open_or_load_model( sys, use_open_system )
%OPEN_OR_LOAD_MODEL Summary of this function goes here
%   Detailed explanation goes here
ret = true;

if nargin == 1
    use_open_system = false;
end

if use_open_system || emi.cfg.INTERACTIVE_MODE
    open_system(sys);
else
    load_system(sys);
end

end
