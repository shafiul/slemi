function [dur_vals] = scaling(varargin)
%SCALING Scaling related results
%   Detailed explanation goes here

[result, l] = covexp.r.init(varargin{:});

try
    l.info('--- Scaling Reports ---');
    
    m = struct2table(result.models);
    
    % models without exception
    m_wo_e = m((~m.exception & m.compiles & ~m.peprocess_skipped), : );
        
    emi_r = load(emi.cfg.RESULT_FILE);
    
    emi_stats = emi_r.stats_table;
    
    merged = outerjoin(m_wo_e, emi_stats);
    
    % Turns out a model might not get selected for mutation at lot, the
    % following line raises error in these cases.
    % assert(all(merged.m_id_m_wo_e == merged.m_id_emi_stats));
    
    
    blks_sz = cellfun(@(p) length(p), merged.blocks);

    l.info('block cnt:%d \t avg:\t %f min:%d \t max:%d',...
        numel(blks_sz), mean(blks_sz), min(blks_sz), max(blks_sz));
    
    blks_per_model_label = 'Blocks/Model';
    
    %%% Plot Durations %%%
    
    compile_d = merged.compile_dur;
    pp_dur = cell2mat(merged.pp_duration);
    merged.pp_tot_dur = compile_d + pp_dur;
    
    durations = {'simdur', 'duration', 'pp_tot_dur', 'avg_mut_dur', 'avg_compile_dur', 'avg_difftest_dur'};
    dur_legends = {'Run Seed', 'Coverage', 'DataType', 'Mutant Gen', 'Run Mutant', 'Diff. Test','Avg. Mutation'};
    
    % merged.duration is a cell, convert it to double
    
    merged.duration = cellfun(@(p)p, merged{:, 'duration'});
    
    %[f, lgnd] = utility.plot(blks_sz, merged{:,durations}, dur_legends,...
     %   blks_per_model_label, 'Runtime (sec)', 'log', 'log');
    
    [f] = utility.plot_bar(blks_sz, merged{:,durations}, dur_legends,...
        blks_per_model_label, 'Runtime (sec)','linear','linear');
    %scatter plot for average mutation
    yyaxis right;
    x = 1:size(blks_sz);
    [blkssize_sorted,row_ids]= sort(blks_sz);% get the row id while sorting based on number of blocks /models 
    y = merged{:, 'avg_mut_ops'};
    y = y(row_ids,:); % sorted y based on number of blocks per model
    [lgnd] = utility.plot(x, y,dur_legends,...
        blks_per_model_label, 'Mutations (mean)','linear','linear');
      
    lgnd.Orientation = 'horizontal';
    lgnd.Location = 'northwest';
    lgnd.FontSize = 20;
    
    xlim([0, 148]);% Change this to figure zoomed in or out 
 
    %To convert color stacked bar into black n white hatch patterns
    %Resolution too low since bitmap used: Unusable for latex. 
    % covexp.util.applyhatch_pluscolor(gcf,'wkwkwk', 0,[101010],[],300,1,2);
   
    %To save figure directly to pdf 
    %ax = gca;
    %outerpos = ax.OuterPosition;
    %ti = ax.TightInset; 
    %left = outerpos(1) + ti(1);
    %bottom = outerpos(2) + ti(2);
    %ax_width = outerpos(3) - ti(1) - ti(3);
    %ax_height = outerpos(4) - ti(2) - ti(4);
    %ax.Position = [left bottom ax_width ax_height];

    %fig = gcf;
    %fig.PaperPositionMode = 'auto'
    %fig_pos = fig.PaperPosition;
    %fig.PaperSize = [fig_pos(3) fig_pos(4)];
    %print(fig,'MySavedFile','-dpdf')
    
    
    %x_tick_low = min(blks_sz); %129
    %x_tick_high = max(blks_sz); 
    
    % Clip axes
    
    f.Position = [0 0 1500 200]; % first two are meaningful. Change according to your machine. 
    
    % Mutation Stats
    
    %[f, ~] = utility.plot(blks_sz, merged{:, 'avg_mut_ops'}, [],...
    %    blks_per_model_label, 'Mutations (mean)', 'log', 'log');
    
    %f.Position = [800 800 400 400];
    
    %xlim([x_tick_low, x_tick_hi]);
    %ylim([10e-3,  max(max(merged{:, durations}))])
    ylim([-99,  400]); %y limit for right y axis
    
    % Where are the ticks?
    interval =10;
    sizeofdata =length(blkssize_sorted);
    
    my_x_ticks = 0:interval: sizeofdata; % Ticks every interval    
    my_x_ticks(1)= 1;
    xticks(my_x_ticks);
    
    %my_x_ticks vector based on the blocks/model 
    my_x_ticks= zeros(1,8);
    my_x_ticks(1) = round(blkssize_sorted(1),-2);
    j=2;
    
    for i =interval:interval: sizeofdata
         my_x_ticks(j) =  round(blkssize_sorted(i),-2);
         j=j+1;
    end
    %xtick 6 and 7 are both 600 as 
    my_x_ticks(7)= 700
    %xticks([]);
    
    %
    xticklabels(my_x_ticks);
   
    %xticklabels(utility.exp_plot_ticks(my_x_ticks));
    %xticks(my_x_ticks);
    %xticklabels(utility.exp_plot_ticks(my_x_ticks));
    %%% Others %%%
    
    l.info('Phases:');
    disp(durations);
    
    l.info('Maximum duration (seconds) for each phase:');
    disp(max(merged{:, durations}, [], 1));
    set(findall(gcf,'-property','DefaultAxesFontSize'),'DefaultAxesFontSize',20)
    
    % Phase Duration Percentage
    
    % Filtering out those did not mutated
    
    dur_vals = merged{~isnan(merged.m_id_emi_stats), durations};
    tot_durs = sum(dur_vals, 2);
    dur_fracs = (dur_vals ./ tot_durs) .* 100;
    
    % Commenting out following as percentage is not important
%     blks_sz = cellfun(@(p) length(p), merged{~isnan(merged.m_id_emi_stats), 'blocks'});
%     utility.plot(blks_sz, dur_fracs, [],...
%         blks_per_model_label, 'Experiment Duration (%)', 'log');
    
    % max phase
    
    [~, i] = max(dur_vals, [], 2);
    l.info('Which phase took maximum duration?')
    tabulate(i);
    
    [~, i] = min(dur_vals, [], 2);
    l.info('Which phase took minimum duration?')
    tabulate(i);
    
    % Average durations
    i = mean(dur_fracs, 1);
    l.info('Average duration-fractions:');
    disp(i);
    
    l.info('Total duration (sec): %f', sum(tot_durs));
    
    l.info('Each seed mutated %f times', mean(emi_stats.count_mutants));
    
    %%% Total Runtime as if linear aka CPU time
    
    % Fill missing vals
    
    merged.count_mutants = fillmissing(merged.count_mutants, 'constant', 0);
    merged.avg_mut_dur = fillmissing(merged.avg_mut_dur, 'constant', 0);
    merged.emi_gen_tot_dur = merged.count_mutants .* merged.avg_mut_dur;
    
    dur_vals = merged{:,...
        {'simdur', 'duration', 'pp_tot_dur', 'emi_gen_tot_dur'}};
    
    l.info('Total linear duration: %f minutes', sum(sum(dur_vals)) / 60);
    
catch e
    utility.print_error(e);
end

end
