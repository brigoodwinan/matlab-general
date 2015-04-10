function out = cepstrumOneSidedAutocorr(inSignal,doABS)
% out = cepstrumOneSidedAutocorr(inSignal)
% out = cepstrumOneSidedAutocorr(inSignal,abs?)
% out = cepstrumOneSidedAutocorr(inSignal,abs?,band)
%
% Brian Goodwin, 2015-03-24
%
% 2015-03-26 -- v1
% 2015-03-26 -- v2 (working version)
%
% Computes the cepstrum of the one-sided autocorrelation coefficients for a
% input signal. The output is the absolute value of the cepstrum.
%
% If the "abs?" is set to true, the absolute value of the cepstrum is
% outputted, otherwise, it is not.
%
% v2 Notes
% removed the "band" option from version 1.

inSignal = inSignal-mean(inSignal); % 0 mean
n = numel(inSignal);
inSignal = xcorr(inSignal,'coeff');
inSignal = inSignal(n:2*n-1);

if nargin>1
    if doABS
        out = abs(rceps(inSignal));
    else
        out = rceps(inSignal);
    end
else
    out = rceps(inSignal);
end

return
end