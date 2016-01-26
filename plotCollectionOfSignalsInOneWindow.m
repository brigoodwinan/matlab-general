function varargout = plotCollectionOfSignalsInOneWindow(s,t,varargin)
% plotCollectionOfSignalsInOneWindow(s,t)
% plotCollectionOfSignalsInOneWindow(s1,t1,s2,t2,...,sN,tN)
% [min,max,scaling1,scaling2,...] = plotCollectionOfSignalsInOneWindow(s1,t1,s2,t2,...,sN,tN)
%
% % plotCollectionOfSignalsInOneWindow(ax,s1,t1,s2,t2,...,sN,tN)
%
% Brian Goodwin, 2015-04-02
%
% Takes a collection of signals and plots them all in the same plot window.
% This functions works in a similar way to subplot(n,m,i), but instead of
% making separate windows for each signal, it "stacks" the signals on one
% plot so that they are closer together and non-overlapping.
%
% INPUTS:
% s: a cell structure where each cell is a signal. s can also be a matrix
%     where the signals to be plotted are columnwise.
% t: (optional) the time:
%     - if t is a cell: it is assumed that each cell contains the time values
%         of the corresponding points in "s";
%     - if t is a vector array: it is assumed that each element in "s"
%         contains the same time points, and this will be applied to each
%         signal in cell structure "s".
% s1...N: signals that have the same form of s, but these will be plotted
%     in such a way where they are "on top" of all the signals of "s".
% t1...N: time series (same as t) for each sn.
%
% OUTPUTS:
% scalings: (optional) the scale factors used to plot the secondary signals (s2 and
%         onward) within the plotting window. The first two variables in
%         this output array are the min and max of the plotting window,
%         i.e., [ min, max, scaling1, scaling2, scaling3, ...]
%
% NOTE:
% - Currently, the signals in s1...N are scaled to fit in the bounds of
%     the "s" signal. This should somehow be changed where something like
%     plotyy is employed.
%
% IMPORTANT:
% - If any signal is all zeros (e.g., x = [1,2,3] y = zeros(3,1)), they
%     will displayed as red circles.

numinputs = nargin;
if ishandle(s)
    if strcmp(get(s,'type'),'axes')
        ax = s;
        s = t;
        t = varargin{1};
        varargin = varargin(2:end);
        numinputs = numinputs-1;
    else
        error('Handle provided is not a handle of type "axes".')
    end
else
    ax = gca;
end

if ~iscell(s)
    [n,m] = size(s);
    s = mat2cell(s,n,ones(m,1));
end

% find the mean max of all signals
ns = length(s);
meanMax = zeros(ns,1);
for k = 1:ns
    meanMax(k) = max(max(abs(s{k})));
end
meanMax = rms(meanMax);

separateSigBy = meanMax*2.1;

sepi = separateSigBy;
if numinputs<2
    for k = 1:length(s)
        sepi = sepi-separateSigBy;
        plot(ax,s{k}+sepi,'k')
        hold on
    end
    hold off
else
    if iscell(t)
        for k = 1:length(s)
            sepi = sepi-separateSigBy;
            plot(ax,t{k},s{k}+sepi,'k')
            hold on
        end
        hold off
    else
        for k = 1:length(s)
            sepi = sepi-separateSigBy;
            plot(ax,t,s{k}+sepi,'k')
            hold on
        end
        hold off
    end
end

mxAbs = meanMax;
mnAbs = -(ns-1)*separateSigBy-meanMax;

varargout = cell(nargout,1);
if nargout>1
    varargout{1} = mnAbs;
    varargout{2} = mxAbs;
elseif nargout==1
    varargout{1} = mnAbs;
end

if ~isempty(varargin)
    hold on
    
    
    ns = length(varargin)/2;
    if rem(ns*2,2)
        error('Must provide even number of inputs for plotCollection(i.e., signal and time for each input).')
    end
    
    %{
    newMax = zeros(ns,1);
    for k = 1:ns
        newMax(k) = max(max(abs(varargin{k*2-1})));
    end
    newMax = rms(newMax);
    %}
    i = 3;
    
    for k = 1:2:ns*2
        i = i+1;
        numSigs = length(varargin{k});
        newSpacing = (mxAbs-mnAbs)./(numSigs);
        
        newZero = newSpacing/2+mxAbs;
        t = varargin{k+1};
        
        newMax = 0;
        for kk = 1:numSigs
            newMax = max(max(abs(varargin{k}{kk}(:))),newMax);
        end
        redCircles = false;
        if newMax==0
            newMax = 1;
            redCircles = true;
        else
            newMax = 1/newMax*newSpacing/2;
        end
        
        if nargout>2
            varargout{i} = newMax;
        end
        % newMax = 1/max(max(abs(varargin{k}{kk})))*newSpacing/2;
        sepi = separateSigBy;
        if iscell(t)
            for kk = 1:numSigs
                newZero = newZero-newSpacing;
                % newMax = 1/max(max(abs(varargin{k}{kk})))*newSpacing/2;
                
                if redCircles
                    sepi = sepi-separateSigBy;
                    plot(t{kk},varargin{k}{kk}+sepi,'.r','markersize',20)
                else
                    plot([min(t{kk}),max(t{kk})],[newZero,newZero],'color',[.5 .5 .5])
                    plot(t{kk},varargin{k}{kk}*newMax+newZero)
                end
            end
        else
            for kk = 1:numSigs
                newZero = newZero-newSpacing;
                
                if redCircles
                    sepi = sepi-separateSigBy;
                    plot(t,varargin{k}{kk}+sepi,'.r','markersize',20)
                else
                    plot([min(t),max(t)],[newZero,newZero],'color',[.5 .5 .5])
                    plot(t,varargin{k}{kk}*newMax+newZero)
                end
            end
        end
    end
    hold off
end

end