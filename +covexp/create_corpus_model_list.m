covexp.addpaths();
corpus_cfg = analyze_complexity_cfg();

cov_meta = [];
cur = 1; 

[cov_meta, cur] = do_single_group(corpus_cfg.examples, 'tutorial', '', false, cov_meta, cur);
[cov_meta, cur] = do_single_group(corpus_cfg.simple, 'simple', '', false, cov_meta, cur);
[cov_meta, cur] = do_single_group(corpus_cfg.complex, 'advanced', '', false, cov_meta, cur);
[cov_meta, cur] = do_single_group(corpus_cfg.research, 'others', '', false, cov_meta, cur);

save(covcfg.CORPUS_COV_META, 'cov_meta');

function [all_data, cur] = do_single_group(data, group, basedir, get_path, all_data, cur)
    
    for i = 1:numel(data)
        all_data(cur).sys = data{i};
        all_data(cur).group = group;
        all_data(cur).basedir = basedir;
        
        cur_path = '';
        
        if get_path
            cur_path = get_param(bdroot, 'FileName');
        else
            
        end
        
        all_data(cur).path = cur_path;
        
        cur = cur + 1;
    end
end