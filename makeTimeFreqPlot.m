function ax = makeTimeFreqPlot(varargin)
% makeTimeFreqPlot(x1,x2,...,x3,s,dt,scaling)
% makeTimeFreqPlot(x1,x2,...,x3,s,dt)
% makeTimeFreqPlot(x1,x2,...,x3,s,scaling)
% makeTimeFreqPlot(x1,x2,...,x3,s)
% makeTimeFreqPlot(x1,x2,...,x3,scaling)
% makeTimeFreqPlot(...,'frequency')
% makeTimeFreqPlot(...,'colorbar')
% ax = makeTimeFreqPlot(...)
%
% Brian Goodwin, 2015-03-05
%
% Creates a time frequency plot of data "x". If signal "s" is provided, the
% function creates a subplot with the timefreqency plot on top and the
% signal on the bottom.
%
% INPUTS:
% x1..xN: m-by-n matrix where x would be the output from x = stockwell(s). m is
%     frequency axis and n is time axis. All x's must have equal n.
% s: 1D signal
% dt: time step or time vector (n-by-1)
% scaling: (optional) 1-by-2 array of the values to scale the color bar to.
%     This is the last input of the imagesc function (e.g., [0,0.5],
%     default is [ 1.1*min(x1(:)) , 0.9*max(x1(:)) ].
% string input: 
%     'frequency': then the output is time-frequency.
%     'colorbar': the colorbar is shown
%     'colorbarLabel': The subsequent string must be the desired label for
%          the colorbar. i.e. (...,'colorbarLabel','Time (ms)')
%     'xlabel': the subsequent string must be the desired label for the
%          x-axis of all the plots. Label will be placed on the bottom most
%          plot.
%
% OUTPUTS:
% ax: axis array of the subplot handles.

% Settings...

tmp = findCellsThatHaveMatchingStringLogical(varargin,'frequency');
isFreq = any(tmp);
varargin = varargin(~tmp);
tmp = findCellsThatHaveMatchingStringLogical(varargin,'colorbarlabel');
if any(tmp)
    colorbarLabel = varargin{find(tmp)+1};
    tmp(find(tmp)+1) = true;
end
varargin = varargin(~tmp);
tmp = findCellsThatHaveMatchingStringLogical(varargin,'colorbar');
setColorbarOn = any(tmp);
varargin = varargin(~tmp);
tmp = findCellsThatHaveMatchingStringLogical(varargin,'xlabel');
if any(tmp)
    xlab = varargin{find(tmp)+1};
    tmp(find(tmp)+1) = true;
end
varargin = varargin(~tmp);

nin = numel(varargin);

a = zeros(nin,1);
b = zeros(nin,1);
for k = 1:nin
    [a(k),b(k)] = size(varargin{k});
end

indTF = a>1 & b>1;

for k = 1:nin
    tmp = varargin{k};
    tmpn = b(k)*a(k);
    
    if tmpn==2
        scaling = tmp;
    elseif (a(k)==1 || b(k)==1) || (tmpn>2 && k>1)
        if any(diff(tmp)<0)
            s = tmp;
        else
            dt = tmp;
        end
    end
end

if exist('s','var')
    nlen = length(s);
else
    nlen = size(varargin{1},2);
end

if ~exist('scaling','var')
    scaling = [min(varargin{1}(:))*1.1,max(varargin{1}(:))*0.9];
end

if exist('dt','var')
    if length(dt)>1
        t = dt;
        dt = diff(t(1:2));
    else
        t = dt:dt:dt*nlen;
    end
else
    t = 1:nlen;
end
tn = length(t);
tmpt = t;

nplots = sum(indTF);
axnum = 0;
if exist('s','var')
    axnum = 1;
    if setColorbarOn
        nplots = nplots*2+1;
    else
        nplots = nplots+1;
    end
    ax(1) = subplot(nplots,1,1);
    plot(t,s,'k');
end

for k = 1:sum(indTF)
    axnum = axnum+1;
    if setColorbarOn
        ax(axnum) = subplot(nplots,1,((axnum-2)*2+2):(axnum-2)*2+3); % yikes LOL
    else
        ax(axnum) = subplot(nplots,1,axnum);
    end
    
    if isFreq
        f = linspace(0,1/2/dt,size(varargin{k},1));
    else
        fn = size(varargin{k},1);
        f = 1:fn;
        if fn~=tn
            tmpt = t;
            t = linspace(min(t),max(t),fn);
        end
        
    end
    
    imagesc(t,f,varargin{k},scaling);
    axis xy
    
    t = tmpt;
    
    if setColorbarOn
        c = colorbar('southoutside');
        if exist('colorbarLabel','var')
            c.Label.String = colorbarLabel;
        end
    end
    
    if exist('xlab','var')
        xlabel(xlab);
    end
end
linkaxes(ax,'x');
axis tight