function ret = merge_structs(p)
%MERGE_STRUCTS Summary of this function goes here
%   p is cell or utility.cell containing many structs which 
%   we want to merge to a single struct. Elements in higher index values
%   will override the preceedings.

ret = struct;

n = numel(p);

for j=1:n
    
    if iscell(p)
        s2 = p{j};
    else
        s2 = p.get(j);
    end
    
    f = fieldnames(s2);
    
    for i = 1:length(f)
        ret.(f{i}) = s2.(f{i});
    end
end

end

