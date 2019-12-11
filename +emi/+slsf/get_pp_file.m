function preprocessed_file_name = get_pp_file(sys, loc_input, pp_ext)
%GET_PP_FILE Summary of this function goes here
%   Detailed explanation goes here

if nargin >= 3
    pp_ext = ['.' pp_ext];
else
    warning('Using emi.cfg.MUTANT_PREPROCESSED_FILE_EXT is deprecated');
    pp_ext = emi.cfg.MUTANT_PREPROCESSED_FILE_EXT;
end

preprocessed_file_name = sprintf('%s_%s', sys, emi.cfg.MUTANT_PREPROCESSED_FILE_SUFFIX);
            
if ~ utility.file_exists(loc_input, [preprocessed_file_name pp_ext])
    error('Preprocessed version %s not found!', preprocessed_file_name);
end

end

