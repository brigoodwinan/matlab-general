function varargout = plotCollectionOfSignalsInOneWindow(s,t,varargin)
% plotCollectionOfSignalsInOneWindow(s,t)
% plotCollectionOfSignalsInOneWindow(s1,t1,s2,t2,...,sN,tN)
% [scaling1,scaling2,...] = plotCollectionOfSignalsInOneWindow(s1,t1,s2,t2,...,sN,tN)
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
%         onward) within the plotting window
%
% NOTE: currently, the signals in s1...N are scaled to fit in the bounds of
%     the "s" signal. This should somehow be changed in future versions.

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
if nargin<2
    for k = 1:length(s)
        sepi = sepi-separateSigBy;
        plot(s{k}+sepi,'k')
        hold on
    end
    hold off
else
    if iscell(t)
        for k = 1:length(s)
            sepi = sepi-separateSigBy;
            plot(t{k},s{k}+sepi,'k')
            hold on
        end
        hold off
    else
        for k = 1:length(s)
            sepi = sepi-separateSigBy;
            plot(t,s{k}+sepi,'k')
            hold on
        end
        hold off
    end
end

if ~isempty(varargin)
    hold on
    mxAbs = meanMax;
    mnAbs = -(ns-1)*separateSigBy-meanMax;
    
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
    i = 0;
    varargout = cell(nargout,1);
    for k = 1:2:ns*2
        i = i+1;
        numSigs = length(varargin{k});
        newSpacing = (mxAbs-mnAbs)./(numSigs);
        
        newZero = newSpacing/2+mxAbs;
        t = varargin{k+1};
        
        newMax = 0;
        for kk = 1:numSigs
            newMax = max(max(max(abs(varargin{k}{kk}))),newMax);
        end
        
        newMax = 1/newMax*newSpacing/2;
        varargout{i} = newMax;
        % newMax = 1/max(max(abs(varargin{k}{kk})))*newSpacing/2;
        
        if iscell(t)
            for kk = 1:numSigs
                newZero = newZero-newSpacing;
                % newMax = 1/max(max(abs(varargin{k}{kk})))*newSpacing/2;
                plot(t{kk},varargin{k}{kk}*newMax+newZero)
                plot([min(t{kk}),max(t{kk})],[newZero,newZero],'color',[.5 .5 .5])
            end
        else
            for kk = 1:numSigs
                newZero = newZero-newSpacing;
                plot(t,varargin{k}{kk}*newMax+newZero)
                plot([min(t),max(t)],[newZero,newZero],'color',[.5 .5 .5])
            end
        end
    end
    hold off
end

end