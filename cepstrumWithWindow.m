function out = cepstrumWithWindow(inSignal,band)
%
% DEPRECATED
%
% out = cepstrumWithWindow(inSignal,band)
%
% Brian Goodwin, 2015-03-26
%
% Given a bandwidth of interest, the cepstrum is computed using a square
% window of the FFT within the bandwidth
%
% INPUTS:
% inSignal: n-by-1 signal
% band: 1-by-2 bandwidth (normalized to 1). e.g., band = [.2,.3]
%
% OUTPUTS:
% out: real cepstrum of the FFT with the bandwidth window.

w = makeFFTWindowForCepstrum(numel(inSignal),band);

out = real(ifft(log(abs(fft(inSignal).*w))));