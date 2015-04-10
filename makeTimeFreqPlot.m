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
% x: m-by-n matrix where x would be the output from x=stran(s). m is
%     frequency axis and n is time axis.
% s: 1D signal
% dt: time step

nlen = size(x,2);

if nargin<3
    figure
    imagesc(dt:dt:dt*nlen,linspace(0,1,size(x,1)),abs(x));
    axis xy
else
    figure
    ax(1) = subplot(2,1,1);
    plot(dt:dt:dt*nlen,s,'k');
    axis tight
    ax(2) = subplot(2,1,2);
    imagesc(dt:dt:dt*nlen,linspace(0,1/2/dt,size(x,1)),abs(x));
    axis xy
    linkaxes(ax,'x');
end