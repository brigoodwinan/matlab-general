function saveFigureEps(fig,width,height,filename,varargin)
% saveFigureEps(figHandle,width,height,filename,option1,value1,option2,value2)
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
%
% Options include:
%   'units'

fig.PaperUnits = 'inches';

fig.PaperPositionMode = 'manual';

if ~isempty(varargin)
    for k = 1:2:length(varargin)
        if strcmpi(varargin{k},'units')
            fig.PaperUnits = varargin{k+1};
        end
    end
end
fig.PaperPosition = [0 0 width height];
ax = findall(fig,'type','axes');

for k = 1:size(ax)
    ax(k).FontName = 'Arial';
    ax(k).FontSize = 10;
end
print(filename,'-depsc2')
