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
%   'pdf'
%
% If any string after filename is == 'pdf', then the image is saved as a
% PDF instead of an eps.
%
% If 'units' is specialized, the next string must be a string with the type
% of unit desired. The string must be in accordance with
% set(figHandle,'PaperUnits','...'). The default is 'inches'.
%
% Can also 

fig.PaperUnits = 'inches';
fig.Renderer = 'painters';

fig.PaperPositionMode = 'manual';
% fig.PaperSize = [width,height];

fig.Renderer = 'painters';

if ~isempty(varargin)
    if any(findCellsThatHaveMatchingStringLogical(varargin,'units'))
        fig.PaperUnits = varargin{findCellsThatHaveMatchingString(varargin,'units')+1};
    end
end

fig.PaperPosition = [0 0 width height];
set(fig,'PaperSize',[width,height]);
% fig.PaperSize = [width,height];
ax = findall(fig,'type','axes');

for k = 1:size(ax)
    ax(k).FontName = 'Helvitica';
    ax(k).FontSize = 10;
end

if ~isempty(varargin)
    if any(findCellsThatHaveMatchingStringLogical(varargin,'pdf'))
        print(filename,'-dpdf')
    else
        print(filename,'-depsc2')
    end
else
    print(filename,'-depsc2')
end
