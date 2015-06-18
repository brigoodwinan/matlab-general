function [Hd,gd] = makeDifferentiator(N)
% Hd = makeDifferentiator
% Hd = makeDifferentiator(or)
% [Hd,gd] = makeDifferentiator(or)
%
% Returns a discrete-time filter object.
%
% Brian Goodwin 2014-02-23
%
% Creates a differentiator filter.
%
% INPUT:
% or: (optional) filter order.
%
% OUTPUT:
% Hd: discrete filter object.
% gd: group delay of filter.
%
% MATLAB Code
% Generated by MATLAB(R) 8.0 and the Signal Processing Toolbox 6.18.
%
% Generated on: 23-Feb-2015 16:49:25
%

% Equiripple Differentiator filter designed using the FIRPM function.

% All frequency values are normalized to 1.

if ~nargin
    N = 40; % Filter order
end

F = [0 0.5 0.55 1];  % Frequency Vector
A = [0 1 0 0];       % Amplitude Vector
W = [1 1];           % Weight Vector

% Calculate the coefficients using the FIRPM function.
b  = firpm(N, F, A, W, 'differentiator');
Hd = dfilt.dffir(b);

if nargout>1
    gd = grpdelay(Hd,3);
    gd = gd(2);
end
end
