function [ covdata ] = get_single_model_coverage( sys, model_id, model_path, cur_exp_dir )
%GET_SINGLE_MODEL_COVERAGE Gets coverage and other information for a model
%   Potentially to be called from a parfor loop

    report_loc = covexp.get_model_cache_filename(sys, model_id, model_path);

    do_append = false;
    
    covdata = struct;
    
    if covcfg.MERGE_RESULTS_ONLY || covcfg.USE_CACHED_RESULTS
        try
            covdata = load(report_loc);
            do_append = true;
            if covcfg.MERGE_RESULTS_ONLY || ~ covcfg.FORCE_UPDATE_CACHED_RESULT
                return;
            end
        catch
        end
    end
    
    if ~isempty(model_path)
        addpath(model_path);
    end
    
    cur_datetime = datestr(now, covcfg.DATETIME_DATE_TO_STR);
    
    touch_loc = start_touch(cur_exp_dir, model_id, cur_datetime);
    
    if ~covcfg.REUSE_CACHED_RESULT
        covdata = struct;
    end
    
    % Init result data structure
    covdata = covexp.init_results(covcfg.DO_THESE_EXPERIMENTS, covdata);
    
    [covdata, h] = covexp.experiments.check_model_opens(sys, model_id, model_path, covdata);
    
    error_exp = [];
    
    if ~ covdata.skipped && covdata.opens
        
        for i = 1:numel(covcfg.DO_THESE_EXPERIMENTS)
            try
                cur_experi = covcfg.EXPERIMENTS{covcfg.DO_THESE_EXPERIMENTS(i)};
                covdata = cur_experi(sys, h, covdata);
            catch e
                % Bug in your code! Fix it!
                utility.print_error(e);
                error_exp = i;
                % Experiments may depend on previous experiment's data, so
                % do not run the following experiments till this bug is
                % fixed.
                break; 
            end
        end
        
        covexp.sys_close(sys);

    end
    
    if ~isempty(model_path)
        rmpath(model_path);
    end
    
    % All clean-ups done. Throw so that you know you have a bug to fix. 
    % Will not change the cached result
    % Maybe its a good idea to leave the touched file so that we know
    % something unexpected happenned? 
    
    if ~ isempty(error_exp)
        throw(MException('covexp:exp:crash', int2str(error_exp)));
    end
    
    if ~iscell(covcfg.DO_THESE_EXPERIMENTS) % array
        is_exp5_only = isscalar(covcfg.DO_THESE_EXPERIMENTS) && ...
            covcfg.DO_THESE_EXPERIMENTS == 5;
    else % cell
        is_exp5_only = numel(covcfg.DO_THESE_EXPERIMENTS) == 1 && ...
                        covcfg.DO_THESE_EXPERIMENTS{1} == 5 ;
    end
    
    if do_append && ~ is_exp5_only
        % EXP#5 may delete some fields, appending would not be correct.
        % Running exp#5 only means we are fixing some cached data.
        save(report_loc, '-append', '-struct', 'covdata');
    else
        save(report_loc, '-struct', 'covdata');
    end

    end_touch(touch_loc);

end


function touch_loc = start_touch(cur_exp_dir, model_id, cur_datetime)
% Only touch dummy when PARFOR is used for efficiency

    if ~ covcfg.PARFOR
        touch_loc = [];
        return;
    end

    touch_loc = [cur_exp_dir filesep covcfg.TOUCHED_MODELS_DIR...
        filesep cur_datetime '___' num2str(model_id) '.txt'];
    
    dummy = 'a'; %#ok<NASGU>
    save(touch_loc, 'dummy');
end


function end_touch(touch_loc)
    if isempty(touch_loc)
        return;
    end
    
    % Delete the touched file
    delete(touch_loc);
end

