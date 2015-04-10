function plotCollectionOfSignalsInOneWindow(s,t)
% plotCollectionOfSignalsInOneWindow(s,t)
%
% Brian Goodwin, 2015-04-02
%
% Takes a collection of signals and plots them all in the same plot window.
% This functions works in a similar way to subplot(n,m,i), but instead of
% making separate windows for each signal, it "stacks" the signals on one
% plot so that they are closer together and non-overlapping.
%
% INPUTS:
% s: a cell structure where each cell is a signal.
% t: (optional) the time:
%     - if t is a cell: it is assumed that each cell contains the time values
%         of the corresponding points in "s";
%     - if t is a vector array: it is assumed that each element in "s"
%         contains the same time points, and this will be applied to each
%         signal in cell structure "s".

% find the mean max of all signals
ns = length(s);
meanMax = zeros(ns,1);
for k = 1:ns
    meanMax(k) = max(abs(s{k}));
end
meanMax = rms(meanMax);

separateSigBy = meanMax*2;

figure

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
end