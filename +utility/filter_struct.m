function [ ret ] = filter_struct( S, field_to_apply_filter, field_to_return, desired_filter_value )
%FILTER_STRUCT Retrive values of field `field_to_return` from struct array `S`
%   Output is returned in a cell
%   Filter logic: S.field_to_apply_filter == desired_filter_value
%   Actually, `group_comparison_fun` is used based on data type of
%   `desired_filter_value`, which can be character vector or boolean (tested).
%   However, any type supporting == should work, though not tested.
%   As an example, see the Struct_filterTest test case.

if ischar(desired_filter_value)
    group_comparison_fun = @strcmp; % fun used to find the desired group index
    group_cols = {S.(field_to_apply_filter)};
else
    group_comparison_fun = @(p, q) p==q;
    group_cols = [S.(field_to_apply_filter)];
end

[groups, unique_group_names] = findgroups(group_cols);

split_results = splitapply(@(arg){arg}, {S.(field_to_return)}, groups);

desired_group_index = find(group_comparison_fun(unique_group_names, desired_filter_value));

ret = split_results{desired_group_index}; %#ok<FNDSB>

end
