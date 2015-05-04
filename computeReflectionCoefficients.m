function [K,A,t] = computeReflectionCoefficients(inSig,windowSize,windowOverlap,maxLag)
% [K,A,t] = computeReflectionCoefficients(inSig,windowSize,windowOverlap,maxLag)
% [K,A,t] = computeReflectionCoefficients(inSig,windowSize,windowOverlap)
%
% Brian Goodwin 2015-04-24
%
% Computes the reflection coefficients of an input signal.
%
% Requires the DSP toolbox and Matlab 2015.
%
% INPUT:
% inSig: n-by-1 time series vector. If inSig is n-by-2, the 2nd column is
%     the time-stamp for each point.
% windowSize: point length of window.
% windowOverlap: either a decimal (0 >= windowOverlap > 1) or integer
%     (0 >= windowOverlap > windowSize) of the number of points to overlap.
% maxLag: maximum number of lags of the autocorrelation to compute for
%     levinson equation (default = 10).
%
% OUTPUT:
% K: maxLag-by-M matrix of the reflection coefficients for each window of
%     the signal.
% A: LPCs (linear prediction coefficients)
% t: 1-by-M array of the first timepoint of each window. (only if inSig is
%     n-by-2 - see INPUT: inSig).

if size(inSig,2)>1
    t = inSig(:,2);
    inSig = inSig(:,1);
end

if exist('t','var')
    [winSig,I] = divideSignalIntoWindows(inSig,windowSize,windowOverlap);
    t = t(I(1,:));
else
    winSig = divideSignalIntoWindows(inSig,windowSize,windowOverlap);
end

hlevinson = dsp.LevinsonSolver;
hlevinson.AOutputPort = true; % Output polynomial coefficients
hac = dsp.Autocorrelator;
hac.MaximumLagSource = 'Property';

if nargin<4
    maxLag = 10;
end

hac.MaximumLag = maxLag; % Compute autocorrelation lags between

% Main for loop for computing the cepstral coefficients for the signal.
[N,M] = size(winSig);
if isPoolOpen
    K = cell(1,M);
    A = cell(1,M);
    winSig = mat2cell(winSig,N,ones(1,M));
    parfor k = 1:M
        a = step(hac, winSig{k});
        [A{k},K{k}] = step(hlevinson, a); % Compute LPC coefficients
    end
    K = cell2mat(K);
    A = cell2mat(A);
else
    K = zeros(maxLag,M);
    A = zeros(maxLag+1,M);
    for k = 1:M
        a = step(hac, winSig(:,k));
        [A(:,k),K(:,k)] = step(hlevinson, a); % Compute LPC coefficients
    end
end