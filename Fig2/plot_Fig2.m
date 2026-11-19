% Fig2: homogeneous states, PD1 multipliers and round-trip evolution.
% S=7.2, F=10, chi=0.5; HSS stability refers to k=0 perturbations.
% Run to display saved results. No solver or file export is called.
folder = fileparts(mfilename('fullpath'));
saved = load(fullfile(folder, 'Fig2_data.mat'), 'dataset', 'curves');
dataset = saved.dataset; curves = saved.curves;
fig = figure('Name', 'Fig2', 'NumberTitle', 'off', 'Position', [100 60 1050 950]);
set(fig, 'DefaultAxesFontSize', 12, 'DefaultAxesBox', 'on', 'DefaultLineLineWidth', 1);

%% Homogeneous-state branches.
blue = [.18 .39 .59]; light = [.53 .68 .82];
a = subplot(4,2,[1 2]);
plot_curves(a, curves.branches);
axis(a, [-2 55 0 66]);
xlabel(a, 'Detuning, \Delta'); ylabel(a, 'Intensity'); title(a, 'HSS branches');
h1 = plot(a, nan, nan, '-', 'Color', blue); h2 = plot(a, nan, nan, '-', 'Color', light);
legend(a, [h1 h2], {'Ikeda map','LLE'}, 'Location', 'best', 'AutoUpdate', 'off');

%% Uniform (k=0) multipliers before and after PD1.
spectra = dataset.hss.PD1_spectra; sides = ["before" "after"]; labels = ["i" "ii"];
for k = 1:2
    T = spectra(spectra.sideOfPD1 == sides(k), :);
    ax = subplot(4,2,k+2);
    plot_spectrum(ax, complex(T.rhoReal,T.rhoImag), hypot(T.rhoReal,T.rhoImag)>1+1e-6);
    title(ax, labels(k)+": \Delta="+string(T.detuning(1)));
end

%% Round-trip traces and the complete saved evolution arrays.
models = ["ikeda" "lle"]; names = ["Ikeda map" "LLE"]; markers = {'s','^'};
colors = [blue; light]; samples = dataset.hss.Fig2_evolution;
traces = dataset.hss.Fig2_traces;
for k = 1:2
    T = samples(samples.model == models(k), :);
    n = unique(T.roundtrip, 'stable'); tau = unique(T.tau, 'stable');
    values = traces.ikedaIntensityPostCoupler;
    if k == 2, values = traces.lleUpperHssIntensity; end
    ax = subplot(4,2,k+4);
    plot(ax, n, values, '-', 'Color', colors(k,:), 'Marker', markers{k}, ...
        'MarkerSize', 5, 'MarkerFaceColor', colors(k,:));
    axis(ax, [.5 8.5 14.5 23.5]); xticks(ax, [1 4 8]);
    xlabel(ax, 'Roundtrips'); ylabel(ax, '|E|^2'); title(ax, names(k)+", \Delta=15");
    ax = subplot(4,2,k+6);
    imagesc(ax, [n(1) n(end)], [tau(1) tau(end)], reshape(T.intensity,256,8));
    set(ax, 'YDir', 'normal'); clim(ax, [15 23]); xticks(ax, [1 4 8]);
    xlabel(ax, 'Roundtrips'); ylabel(ax, 'Fast time, \tau');
    cb = colorbar(ax); cb.Label.String = 'Intensity';
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
