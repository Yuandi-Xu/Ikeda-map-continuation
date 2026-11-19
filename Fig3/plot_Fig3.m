% Fig3: HSS/Turing/CS branches, profiles and Floquet multipliers.
% S=2.8, F=20, chi=0.5; profiles at Delta=9.5.
% Run to display saved results. No solver or file export is called.
folder = fileparts(mfilename('fullpath'));
saved = load(fullfile(folder, 'Fig3_data.mat'), 'dataset', 'curves');
dataset = saved.dataset; curves = saved.curves;
fig = figure('Name', 'Fig3', 'NumberTitle', 'off', 'Position', [80 100 1300 700]);
set(fig, 'DefaultAxesFontSize', 12, 'DefaultAxesBox', 'on', 'DefaultLineLineWidth', 1);

%% Branches and the two saved CS profiles.
a = subplot(2,4,[1 2]); plot_curves(a, curves.branches);
axis(a, [-2 10.5 0 21.5]);
xlabel(a, 'Detuning, \Delta'); ylabel(a, 'Peak intensity'); title(a, 'HSS, MI and CS branches');
text(a, 0, 3.2, 'HSS', 'Color', [.18 .39 .59]);
text(a, -.5, 9.2, 'MI', 'Color', [.14 .48 .24]);
text(a, 6.1, 17.4, 'CS', 'Color', [.72 .25 .15]);
h1 = plot(a, nan, nan, '-', 'Color', [.2 .2 .2]);
h2 = plot(a, nan, nan, '-', 'Color', [.6 .6 .6]);
legend(a, [h1 h2], {'Ikeda map','LLE'}, 'Location', 'southeast', 'AutoUpdate', 'off');
b = subplot(2,4,3); hold(b, 'on');
models = ["LLE" "Ikeda"]; colors = [.8656 .64 .592; .72 .25 .15];
for k = 1:2
    T = dataset.fig3.(char(models(k)+"_profile"));
    plot(b, T.tau, T.intensity, 'Color', colors(k,:));
end
axis(b, [-4 4 0 21.5]); xlabel(b, 'Fast time, \tau'); ylabel(b, 'Intensity');
title(b, 'CS profiles, \Delta=9.5'); legend(b, {'LLE','Ikeda map'}, 'Location', 'southoutside');

%% Enlarged CS branches.
zoom = subplot(2,4,4); plot_curves(zoom, curves.inset);
axis(zoom, [4.62 5.18 11.5 12.52]);
xlabel(zoom, 'Detuning, \Delta'); ylabel(zoom, 'Peak intensity'); title(zoom, 'CS enlargement');

%% Four saved spectra, with all 256 stored multipliers in each panel.
spectra = dataset.fig3.CS_spectra_top256; labels = ["i" "ii" "iii" "iv"];
for k = 1:4
    T = spectra(spectra.panel == labels(k), :); state = dataset.metadata.Fig3_states(k);
    ax = subplot(2,4,k+4);
    plot_spectrum(ax, complex(T.realRho,T.imagRho), T.outside);
    title(ax, labels(k)+": \Delta="+string(state.Delta));
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
