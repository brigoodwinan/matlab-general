function [CC,K,A,t] = computeCepstralCoefficients(inSig,windowSize,windowOverlap,nCoef,maxLag,noParallel)
% [CC,K,A,t] = computeCepstralCoefficients(inSig,windowSize,windowOverlap,nCoef,maxLag)
% CC = computeCepstralCoefficients(inSig,windowSize,windowOverlap,nCoef)
% CC = computeCepstralCoefficients(inSig,windowSize,windowOverlap)
%
% Brian Goodwin 2015-04-24
%
% Computes the cepstral coefficients of an input signal.
%
% Requires the DSP toolbox and Matlab 2015.
%
% INPUT:
% inSig: n-by-1 time series vector. If inSig is n-by-2, the 2nd column is
%     the time-stamp for each point.
% windowSize: point length of window.
% windowOverlap: either a decimal (0 >= windowOverlap > 1) or integer
%     (0 >= windowOverlap > windowSize) of the number of points to overlap.
% nCoef: number of cepstral coefficients (optional; default = 9).
% maxLag: maximum number of lags of the autocorrelation to compute for
%     levinson equation (default = 10).
% noParallel: (optional) a logical value - if true, it forces the function
%     to avoid using parallel processing. This is relevant if you are
%     running this function within a parfor loop; this would avoid running
%     a parfor within a parfor loop.
%
% OUTPUT:
% CC: nCoef-by-M matrix of the cepstral coefficients for each window of
%     the signal.
% K: maxLag-by-M matrix of the reflection coefficients for each window of
%     the signal.
% A: LPCs (linear prediction coefficients)
% t: 1-by-M array of the first timepoint of each window. (only if inSig is
%     n-by-2 - (see INPUT: inSig).

if nargin<6
    noParallel = false;
end

if size(inSig,2)>1
    t = inSig(:,2);
    inSig = inSig(:,1);
end

if exist('t','var')
    [winSig,I] = divideSignalIntoWindows(inSig,windowSize,windowOverlap);
    t = t(I(fix(windowSize/2),:)); % changed from "1" to "fix(windowSize/2)" 2016-01-26 bdg
else
    winSig = divideSignalIntoWindows(inSig,windowSize,windowOverlap);
end

hlevinson = dsp.LevinsonSolver;
hlevinson.AOutputPort = true; % Output polynomial coefficients
hac = dsp.Autocorrelator;
hac.MaximumLagSource = 'Property';

if nargin<5
    maxLag = 10;
end

hac.MaximumLag = maxLag; % Compute autocorrelation lags between

if nargin>3
    if isempty(nCoef)
        nCoef = 9;
    end
else
    nCoef = 9;
end

hlpc2cc = dsp.LPCToCepstral('CepstrumLength',nCoef);

% Main for loop for computing the cepstral coefficients for the signal.
[N,M] = size(winSig);
if isPoolOpen && ~noParallel
    CC = cell(1,M);
    K = CC;
    A = CC;
    winSig = mat2cell(winSig,N,ones(1,M));
    parfor k = 1:M
        a = step(hac, winSig{k});
        [A{k},K{k}] = step(hlevinson, a); % Compute LPC coefficients
        CC{k} = step(hlpc2cc, A{k}); % Convert LPC to CC.
    end
    CC = cell2mat(CC);
    K = cell2mat(K);
    A = cell2mat(A);
    return
else
    CC = zeros(nCoef,M);
    K = zeros(maxLag,M);
    A = zeros(maxLag+1,M);
    for k = 1:M
        a = step(hac, winSig(:,k));
        [A(:,k),K(:,k)] = step(hlevinson, a); % Compute LPC coefficients
        CC(:,k) = step(hlpc2cc, A(:,k)); % Convert LPC to CC.
    end
    return
end