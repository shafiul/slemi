function ret = delete_connection(sys, s_b, s_p, d_b, d_p, is_if,...
    replace, rep_is_src)
%% Delete a connection
% % Delete existing lines. If `replace` is not empty then add new
% connections.
% if `rep_is_src`: adds replace --> d_b
%           else : adds s_b --> replace   

if nargin < 7
    replace = [];
end

if ~ iscell(d_b)
    d_b = {d_b};
end

for i=1:numel(d_b)
    if is_if
        dest_port = 'ifaction';
    else
        dest_port = int2str(d_p(i));
    end
    
    delete_line(sys, [s_b '/' s_p], [d_b{i} '/' dest_port]);
    
    if ~ isempty(replace)
        if rep_is_src
            add_line(sys, [replace '/' s_p], [d_b{i} '/' dest_port], 'autorouting','on');
        else
            add_line(sys, [s_b '/' s_p], [replace '/' dest_port], 'autorouting','on');
        end
    end

end

ret = true;

end