function out = cepstrumOneSidedAutocorr(inSignal,doABS,band)
% out = cepstrumOneSidedAutocorr(inSignal)
% out = cepstrumOneSidedAutocorr(inSignal,abs?)
% out = cepstrumOneSidedAutocorr(inSignal,abs?,band)
%
% Brian Goodwin, 2015-03-24
%
% 2015-03-26 -- v1 (working version)
%
% Computes the cepstrum of the one-sided autocorrelation coefficients for a
% input signal. The output is the absolute value of the cepstrum.
%
% If the "abs?" is set to true, the absolute value of the cepstrum is
% outputted, otherwise, it is not.
%
% If the "band" variable is provided, then the FFT is windowed by a square
% window within the bandwidth (normalized, i.e., between 0 and 1 where 1 is
% nyquist).

inSignal = inSignal-mean(inSignal); % 0 mean
n = numel(inSignal);
inSignal = xcorr(inSignal,'coeff');
inSignal = inSignal(n:2*n-1);

if nargin>1
    if nargin>2
        if doABS
            out = abs(cepstrumWithWindow(inSignal,band));
        else
            out = cepstrumWithWindow(inSignal,band);
        end
    else
        if doABS
            out = abs(rceps(inSignal));
        else
            out = rceps(inSignal);
        end
    end
else
    out = rceps(inSignal);
end

return
end