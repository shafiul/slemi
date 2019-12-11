function ret = init_struct_array(first_elem, target_sz)
%INIT_STRUCT_ARRAY Create Struct array of `target_sz` structs and
%initialize the first one with `first_elem`
% Done for efficient memory allocation
fns = fieldnames(first_elem)';      % 1Xn 
fns(2,:) = cell(1, numel(fns)); % 2Xn; second row is empty values

ret(target_sz) = struct(fns{:});
ret(1) = first_elem;
end

