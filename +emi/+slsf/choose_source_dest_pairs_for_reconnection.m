function result = choose_source_dest_pairs_for_reconnection(sources, dests)
    result = utility.cell();

    single = struct; % single element in result

    source_ptr = 0;

    for d = 1:size(dests, 1)
        cur_d = dests{d, :};

        d_blk = get_param(cur_d{2}, 'Name');
        d_prt = cur_d{3} + 1;

        if ~ iscell(d_blk)
            d_blk = {d_blk};
        end

        for j = 1: numel(d_blk)
            single.d_blk = d_blk{j};
            single.d_prt = d_prt(j);
            
            % Choose source

            source_ptr = source_ptr +1;
            src_i = source_ptr;

            if src_i > size(sources, 1)
                src_i = 1; % TODO select random
            end

            cur_src = sources(src_i, :);
            cur_src = table2cell(cur_src);

            single.s_blk = get_param(cur_src{2}, 'Name');
            single.s_prt = cur_src{3} + 1;

            result.add(single);
        end
    end
end