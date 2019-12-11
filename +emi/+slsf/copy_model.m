function new_model_full_path = copy_model(sys,dest_dir, new_filename, ext)
%COPY_MODEL Summary of this function goes here
%   WARNING if ext is not provided, the model must already be loaded.

if nargin == 3
    ext = emi.slsf.get_extension(sys);
end

new_model_full_path = [dest_dir filesep new_filename '.' ext];

save_system(sys, new_model_full_path);
end

