function ret = get_struct_from_object( p, except_these )
%GET_STRUCT_FROM_OBJECT Get p's properties in a struct
%   Detailed explanation goes here
ret = struct;

if nargin == 1
    except_these = containers.Map();
end

prop_names = properties(p);

for i=1:length(prop_names)
    k = prop_names{i};
    
    if except_these.isKey(k)
        continue;
    end
    
    ret.(k) = p.(k);
end

end

