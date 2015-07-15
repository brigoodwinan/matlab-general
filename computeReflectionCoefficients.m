function [K,A,t] = computeReflectionCoefficients(inSig,windowSize,windowOverlap,maxLag)
% [K,A,t] = computeReflectionCoefficients(inSig,windowSize,windowOverlap,maxLag)
% [K,A,t] = computeReflectionCoefficients(inSig,windowSize,windowOverlap)
%
% Brian Goodwin 2015-04-24
%
% Computes the reflection coefficients of an input signal. Another option
% would be to use the schurrc() function.
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
%     levinson equation (default = 16).
%
% OUTPUT:
% K: maxLag-by-M matrix of the reflection coefficients for each window of
%     the signal.
% A: LPCs (linear prediction coefficients)
% t: 1-by-M array of the middle timepoint of each window. (only if inSig is
%     n-by-2 - see INPUT: inSig). If no "time" column in "inSig" is
%     supplied, then "t" will contain all the indices that lie in the
%     middle of the windows.

if size(inSig,2)>1
    t = inSig(:,2);
    inSig = inSig(:,1);
else
    if nargout>2
        t = uint32(1:length(inSig)); % Set "t" to an integer for outputting index
    end
end

if exist('t','var')
    [winSig,I] = divideSignalIntoWindows(inSig,windowSize,windowOverlap);
    t = t(I(fix(windowSize/2),:)); % the time point is in the middle of the window here, instead of the first time point of each window.
else
    winSig = divideSignalIntoWindows(inSig,windowSize,windowOverlap);
end

hlevinson = dsp.LevinsonSolver;
hlevinson.AOutputPort = true; % Output polynomial coefficients
hac = dsp.Autocorrelator;
hac.MaximumLagSource = 'Property';

if nargin<4
    maxLag = 16;
end

hac.MaximumLag = maxLag; % Compute autocorrelation lags between

% Main for loop for computing the reflection coefficients for the signal.
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