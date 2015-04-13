function makeTimeFreqPlot(x,dt,s)
% makeTimeFreqPlot(x,dt)
% makeTimeFreqPlot(x,dt,s)
%
% Brian Goodwin, 2015-03-05
%
% Creates a time frequency plot of data "x". If signal "s" is provided, the
% function creates a subplot with the timefreqency plot on top and the
% signal on the bottom.
%
% INPUTS:
% x: m-by-n matrix where x would be the output from x = stockwell(s). m is
%     frequency axis and n is time axis.
% s: 1D signal
% dt: time step or time vector (n-by-1)

nlen = size(x,2);

if length(dt)>1
    t = dt;
    dt = diff(t(1:2));
else
    t = dt:dt:dt*nlen;
end

if nargin<3
    figure
    imagesc(t,linspace(0,1/2/dt,size(x,1)),abs(x));
    axis xy
    axis tight
else
    figure
    ax(1) = subplot(2,1,1);
    plot(t,s,'k');
    axis tight
    ax(2) = subplot(2,1,2);
    imagesc(t,linspace(0,1/2/dt,size(x,1)),abs(x));
    axis xy
    linkaxes(ax,'x');
end