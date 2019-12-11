function mavstamp()
%MAVSTAMP Compare Maverick vs. Stampede2 
%   for runtime of first 30 corpus models aka Simulink Examples
loaded_data = load(['workdata' filesep 'mavstamp']);
maverick = loaded_data.maverick;
stampede = loaded_data.stampede;
skx = loaded_data.skx;

% Compare Simulation + Coverage collection runtime


stampede_dur = cellfun(@(p)utility.na(p, @(q)q),{stampede.simdur})...
    + cellfun(@(p)utility.na(p, @(q)q),{stampede.duration});

maverick_dur = cellfun(@(p)utility.na(p, @(q)q),{maverick.simdur})...
    + cellfun(@(p)utility.na(p, @(q)q),{maverick.duration});

skx_dur = cellfun(@(p)utility.na(p, @(q)q),{skx.simdur})...
    + cellfun(@(p)utility.na(p, @(q)q),{skx.duration});

figure();

plot(1:30, maverick_dur + 10e-1);
hold on;
plot(1:30, stampede_dur + 10e-1);
hold on;
plot(1:30, skx_dur + 10e-1);

legend({'Maverick R2017a', 'stmpd KNL R2018B', 'stmpd SKX R2018B'});
xlabel('Corpus Models (1-30)');
ylabel('Simulation + Coverage collection duration in Seconds');

set(gca, 'YScale', 'log');

hold off;

fprintf('Avg: KNL: %f; SKX: %f, Mav: %f',...
    mean(stampede_dur), mean(skx_dur), mean(maverick_dur));

% 
% figure();
% boxplot(stampede_dur-maverick_dur);
% title('Stampede2 duration - Maverick duration');

end

