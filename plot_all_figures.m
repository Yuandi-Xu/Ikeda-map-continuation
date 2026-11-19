% Run the four display-only examples. No files are written.
allFiguresRoot = fileparts(mfilename('fullpath'));
allFigureNames = {'Fig2','Fig3','Fig4','FigS1'};
for figureNumber = 1:numel(allFigureNames)
    figureTag = allFigureNames{figureNumber};
    run(fullfile(allFiguresRoot,figureTag,['plot_' figureTag '.m']));
end
