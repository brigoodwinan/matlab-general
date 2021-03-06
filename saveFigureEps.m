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
%   'units' - subsequent entry must be a string indicating units (e.g.,
%       'centimeters').
%   'pdf' - if this string is present, the file is saved as a pdf.
%   'png' - if this string is present, the file is saved as a png.
%       (optional) Indicate the dpi of the file by specifying in the
%       following input using a string of the format '-r300' (e.g.).
%       e.g., saveFigureEps(...,'png','-r300')
%       (default = '-r500' if not included in inputs)
%   'fontname' - subsequent entry must be a string indicating desired font.
%   'fontsize' - subsequent entry must be a value indicating desired font
%       size.
%
% If any string after "filename" is == 'pdf', then the image is saved as a
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
ax = findall(fig,'type','axes');
if ~isempty(varargin)
    if any(findCellsThatHaveMatchingStringLogical(varargin,'units'))
        fig.PaperUnits = varargin{findCellsThatHaveMatchingString(varargin,'units')+1};
    end
    
    if any(findCellsThatHaveMatchingStringLogical(varargin,'fontname'))
        for k = 1:size(ax)
            ax(k).FontName = varargin{findCellsThatHaveMatchingString(varargin,'fontname')+1};
        end
    else
        for k = 1:size(ax)
            ax(k).FontName = 'Helvetica';
        end
    end
    
    if any(findCellsThatHaveMatchingStringLogical(varargin,'fontsize'))
        for k = 1:size(ax)
            ax(k).FontSize = varargin{findCellsThatHaveMatchingString(varargin,'fontsize')+1};
        end
    else
        for k = 1:size(ax)
            ax(k).FontSize = 10;
        end
    end
else
    for k = 1:size(ax)
        ax(k).FontName = 'Helvetica';
        ax(k).FontSize = 10;
    end
end

fig.PaperPosition = [0 0 width height];
set(fig,'PaperSize',[width,height]);
% fig.PaperSize = [width,height];

if ~isempty(varargin)
    if any(findCellsThatHaveMatchingStringLogical(varargin,'pdf'))
        print(filename,'-dpdf')
    elseif any(findCellsThatHaveMatchingStringLogical(varargin,'png'))
        ind = findCellsThatHaveMatchingString(varargin,'png');
        res = '-r500';
        if length(varargin)>ind
            if strcmp(varargin{ind+1}(1:2),'-r')
                res = varargin{ind+1};
            end
        end
            
        print(filename,'-dpng',res)
    else
        print(filename,'-depsc2')
    end
else
    print(filename,'-depsc2')
end
