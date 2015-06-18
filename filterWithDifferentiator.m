function out = filterWithDifferentiator(x,Hd)
% out = filterWithDifferentiator(x,Hd)
%
% Brian Goodwin 2015-06-17
%
% Filters a signal using a differentiator.
%
% INPUTS:
% x: n-by-1 (or n-by-m) signal (or m signals)
% Hd: discrete filter object (the differentiator
%
% OUTPUTS:
% out: filtered signal (n-by-1).
%
% see also: makeDifferentiator()

gd = grpdelay(Hd,4);
gd = fix(gd(2));
x = filter(Hd,x);
out = circshift(x,-gd,1);