classdef block_compiled_data 
%BLOCK_COMPILED_DATA Summary of this function goes here
%   Note: Copy  semantics: value

properties
    datatype;
    st;
end

methods
    
    function obj = block_compiled_data(dt, st)
        obj.datatype = dt;
        obj.st = st;
    end
    
end

end

