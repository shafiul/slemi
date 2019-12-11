function output_args = unique( input_args )
%UNIQUE Summary of this function goes here
%   I suspect MATLAB's UNIQUE is nlogn... as it returns in sorted order

output_args = tabulate(input_args);
output_args = output_args(:,1);
end

