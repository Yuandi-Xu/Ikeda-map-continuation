% FigS1: homogeneous-state period doubling and round-trip sequences.
% S=7.2, F=10, chi=0.5; the P2 trace is approximately at Delta=18.5.
% Run to display saved results. No solver or file export is called.
folder = fileparts(mfilename('fullpath'));
saved = load(fullfile(folder, 'FigS1_data.mat'), 'dataset', 'curves');
dataset = saved.dataset; curves = saved.curves;
fig = figure('Name', 'FigS1', 'NumberTitle', 'off', 'Position', [80 60 1250 850]);
set(fig, 'DefaultAxesFontSize', 12, 'DefaultAxesBox', 'on', 'DefaultLineLineWidth', 1);

%% Period-doubling branches and an enlarged view.
colors = [.46 .46 .46; .18 .39 .59; .72 .25 .15; .14 .45 .28];
a = subplot(3,3,[1 4]); plot_curves(a, curves.branches);
axis(a, [7 42 0 66]); xlabel(a, 'Detuning, \Delta'); ylabel(a, 'Intensity'); title(a, 'HSS branches');
b = subplot(3,3,[2 5]); plot_curves(b, curves.branches);
axis(b, [18 24 17 26]); xlabel(b, 'Detuning, \Delta'); ylabel(b, 'Intensity'); title(b, 'Period-doubling cascade');
h = gobjects(1,6); legendColors = [colors; .25 .25 .25; .6 .6 .6];
for k = 1:6
    style = '-'; if k == 6, style = '--'; end
    h(k) = plot(a, nan, nan, style, 'Color', legendColors(k,:));
end
legend(a, h, {'P1','P2','P4','P8','Stable','Unstable'}, 'Location', 'best');

%% The two actual saved P2 spectra, displayed as separate subplots.
p2 = dataset.hss.P2;
for k = 1:2
    state = dataset.metadata.FigS1_spectrum_states(k); T = p2(state.row_index,:);
    rho = complex([T.rho1Real; T.rho2Real], [T.rho1Imag; T.rho2Imag]);
    ax = subplot(3,3,3*k); plot_spectrum(ax, rho, abs(rho)>1+1e-6);
    title(ax, string(state.label)+": P2 multipliers");
end

%% Complete saved 16-round-trip intensity sequences.
sequences = dataset.hss.FigS1_sequences; periods = [2 4 8]; markers = {'o','s','^'};
limits = [floor(min(sequences.intensity))-1 ceil(max(sequences.intensity))+2];
for k = 1:3
    T = sequences(sequences.period == periods(k), :); ax = subplot(3,3,k+6);
    plot(ax, T.roundtrip, T.intensity, '-', 'Color', colors(k+1,:), ...
        'Marker', markers{k}, 'MarkerSize', 5, 'MarkerFaceColor', colors(k+1,:));
    xlim(ax, [.5 16.5]); ylim(ax, limits); xticks(ax, [1 8 16]);
    xlabel(ax, 'Roundtrips'); ylabel(ax, 'Intensity');
    label = sprintf('P%d, \\Delta=%.1f', periods(k), T.detuning(1));
    if k == 1, label = 'P2, \Delta\approx18.5'; end
    title(ax, label);
end

function plot_curves(ax, curves)
% Each saved run already contains its stability line style and color.
hold(ax, 'on');
for k = 1:numel(curves)
    c = curves(k); plot(ax, c.x, c.y, c.style, 'Color', c.color);
end
end

function plot_spectrum(ax, rho, outside)
% Show saved multiplier points and the unit circle; retain the neutral mode.
hold(ax, 'on'); angle = linspace(0, 2*pi, 361);
plot(ax, cos(angle), sin(angle), ':', 'Color', [.48 .48 .48]);
xline(ax, 0, 'Color', [.84 .84 .84]); yline(ax, 0, 'Color', [.84 .84 .84]);
outside = logical(outside);
plot(ax, real(rho(~outside)), imag(rho(~outside)), '.', 'Color', [.18 .39 .59], 'MarkerSize', 9);
plot(ax, real(rho(outside)), imag(rho(outside)), '.', 'Color', [.75 .18 .12], 'MarkerSize', 10);
axis(ax, 'equal'); axis(ax, [-1.45 1.45 -1.45 1.45]);
xlabel(ax, 'Re({\it\rho})'); ylabel(ax, 'Im({\it\rho})');
end
