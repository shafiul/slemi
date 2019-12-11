function config_mlfun(mlfunblk, funpath)
%CONFIG_MLFUN Configures a MATLAB Function block by reading source from `funpath`
% WARNING `mlfunblk` must be a path and not a handle
%   Copied from MathWorks Documentation: https://www.mathworks.com/help/simulink/ug/creating-an-example-model-that-uses-a-matlab-function-block.html

funbase = ['+emi' filesep 'mlfunasserts'];
funpath = [funbase filesep funpath ];

blockHandle = find(slroot, '-isa', 'Stateflow.EMChart', 'Path', mlfunblk); %#ok<GTARG>
% The Script property of the object contains the contents of the block,
% represented as a character vector. This line of the script loads the
% contents of the file myAdd.m into the Script property:
blockHandle.Script = fileread(funpath);
end

