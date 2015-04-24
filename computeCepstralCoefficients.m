function CC = computeCepstralCoefficients(inSig,windowSize,windowOverlap,nCoef,maxLag)
% CC = computeCepstralCoefficients(inSig,windowSize,windowOverlap,nCoef)
%
% Brian Goodwin 2015-04-24
%
% Computes the cepstral coefficients of an input signal.
%
% Requires the DSP toolbox and Matlab 2015.
%
% INPUT:
% inSig: n-by-1 time series vector.
% windowSize: point length of window.
% windowOverlap: either a decimal (0 >= windowOverlap > 1) or integer
%     (0 >= windowOverlap > windowSize) of the number of points to overlap.
% nCoef: number of cepstral coefficients (optional; default = 9).
% maxLag: maximum number of lags of the autocorrelation to compute for
%     levinson equation (default = 10.
%
% OUTPUT:
% out = nCoef-by-M matrix of the cepstral coefficients for each window of
% the signal.

winSig = divideSignalIntoWindows(inSig,windowSize,windowOverlap);

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
if isPoolOpen
    CC = cell(1,M);
    winSig = mat2cell(winSig,ones(1,N)*N,ones(1,M));
    parfor k = 1:M
        a = step(hac, winSig(:,k));
        A = step(hlevinson, a); % Compute LPC coefficients
        CC{k} = step(hlpc2cc, A); % Convert LPC to CC.
    end
    CC = cell2mat(CC);
else
    CC = zeros(nCoef,M);
    for k = 1:M
        a = step(hac, winSig(:,k));
        A = step(hlevinson, a); % Compute LPC coefficients
        CC(:,k) = step(hlpc2cc, A); % Convert LPC to CC.
    end
end