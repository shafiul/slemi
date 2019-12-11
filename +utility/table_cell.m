function tbl = table_cell(tbl, col)
%TABLE_CELL if col exists in the table make it cell
if ismember(col, tbl.Properties.VariableNames)
    tbl.(col) = utility.s2c(tbl.(col));
end
end

