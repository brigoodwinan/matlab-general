function [ax,h1,h2] = customPlotyy(x1,y1,x2,y2,options)
% [ax,h1,h2] = customPlotyy(x1,y1,x2,y2,options)
%
% Brian Goodwin; 2015-05-26
%
% Creates a custom plotyy where the color of each axis and the limits can
% be set.
%
% INPUTS:
% x1, y1, x2, y2: the x-axis values and y-axis values as for using in
%      plotyy().
% options: a structure with the following sets:
%      color1: 1-by-3 rgb color array for describing the color of the first
%         dataset
%      color2: " " " of the second dataset.
%      ylim1 & ylim2: ylimits for the y-axis of each dataset
%      xlim: the xlimits for the plot.
%      ytick1 & ytick2: the y-tick values for each axis.
%      ygrid1 & ygrid2: boolean (true or false) for turning grids on for
%         y-axis 1 & 2.
%      xgrid: boolean (true or false) for turning x-axis grids on
%      ylabel1 & ylabel2: Y-labels
%      xlabel: X-label
%
% OUTPUTS (optional):
% ax: 1-by-2 axis array describing the first and second axes
% h1: the handle for the first dataset
% h2: the handle for the second dataset

[ax,h1,h2] = plotyy(x1,y1,x2,y2);
linkaxes(ax,'x');
if nargin>4
    if isfield(options,'color1')
        set(h1,'color',options.color1);
        set(ax(1),'ycolor',options.color1);
    end
    if isfield(options,'color2')
        set(h2,'color',options.color2);
        set(ax(2),'ycolor',options.color2);
    end
    if isfield(options,'ylim1')
        set(ax(1),'ylim',options.ylim1);
    end
    if isfield(options,'ylim2')
        set(ax(2),'ylim',options.ylim2);
    end
    if isfield(options,'xlim')
        xlim(options.xlim);
    end
    if isfield(options,'ygrid1')
        if options.ygrid1
            set(ax(1),'ygrid','on');
        end
    end
    if isfield(options,'ygrid2')
        if options.ygrid2
            set(ax(2),'ygrid','on');
        end
    end
    if isfield(options,'xgrid')
        if options.xgrid
            set(ax(1),'xgrid','on');
        end
    end
    if isfield(options,'ytick1')
        set(ax(1),'ytick',options.ytick1);
    end
    if isfield(options,'ytick2')
        set(ax(1),'ytick',options.ytick2);
    end
    if isfield(options,'ylabel1')
        ax(1).YLabel.String = options.ylabel1;
    end
    if isfield(options,'ylabel2')
        ax(2).YLabel.String = options.ylabel2;
    end
    
    % make sure the following if statement is the last one:
    if isfield(options,'xlabel')
        ax = gca;
        ax.XLabel.String = options.xlabel;
    end
end