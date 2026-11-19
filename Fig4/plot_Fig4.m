% Fig4: finesse-dependent branches and upper-CS existence-interval overlap.
% S=2.8, chi=0.5. Run to display saved results; no solver or export is called.
folder = fileparts(mfilename('fullpath'));
saved = load(fullfile(folder, 'Fig4_data.mat'), 'dataset', 'curves');
dataset = saved.dataset; curves = saved.curves;
fig = figure('Name', 'Fig4', 'NumberTitle', 'off', 'Position', [100 150 1100 600]);
set(fig, 'DefaultAxesFontSize', 12, 'DefaultAxesBox', 'on', 'DefaultLineLineWidth', 1);

%% Three finesse cases and the LLE reference.
panels = [1 2 4 5]; names = {'Ikeda map, F=5','Ikeda map, F=10','Ikeda map, F=100','LLE'};
for k = 1:4
    ax = subplot(2,3,panels(k)); hold(ax, 'on');
    for j = 1:numel(curves.cases{k})
        c = curves.cases{k}(j); plot(ax, c.x, c.y, c.style, 'Color', c.color);
    end
    axis(ax, [-2 14 0 24]); title(ax, names{k});
    xlabel(ax, 'Detuning, \Delta'); ylabel(ax, 'Peak intensity');
    if k == 1
        text(ax, 3, 17.5, 'CS', 'Color', [.72 .25 .15]);
        text(ax, -1, 11.5, 'HSS', 'Color', [.18 .39 .59]);
    end
end

%% Plot all eight saved overlap values, without recalculating the intervals.
T = dataset.comparison.overlap; ax = subplot(2,3,[3 6]);
semilogx(ax, T.finesse, T.overlap, '-o', 'Color', [.72 .25 .15], 'MarkerFaceColor', [.72 .25 .15]);
axis(ax, [4.3 1150 .85 1.01]); xticks(ax, [5 10 100 1000]);
xlabel(ax, 'Finesse, F'); ylabel(ax, 'Detuning overlap'); title(ax, 'CS interval overlap');
