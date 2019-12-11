function r = load_cache_or_run(load_cache, cache_name, cache_path, fun)
    if load_cache
        fprintf('Loading from cache...\n');
        if isempty(cache_path)
            cached_r = load(cache_name);
        else
            cached_r = load([cache_path filesep cache_name]);
        end
        r = cached_r.r;
    else
        r = fun();
        target_file = cache_name;
        
        if ~ isempty(cache_path)
            target_file = [cache_path filesep cache_name];
        end
        
        fprintf('Caching result...');
        
        save(target_file, 'r');
    end
end