function saveFigureEps(fig,width,height,filename)
% saveFigureEps(figHandle,width,height,filename)
%
% Brian Goodwin 2015-05-20
%
% Saves a figure as an eps file given dimensions.
%
% Use:
% figHandle = gcf;
%
% width: width of the image in inches
% height: height of the image in inches

fig.PaperUnits = 'inches';
fig.PaperPosition = [0 0 width height];
fig.PaperPositionMode = 'manual';
print(filename,'-depsc2')
