function out = makeFFTWindowForCepstrum(N,band)
%
% DEPRECATED
%
% out = makeFFTWindowForCepstrum(N,band)
%
% Creates a window of the FFT for use in computing the cepstrum. Uses a
% triangular window around the frequency band.
%
% INPUTS:
% N: length of FFT
% band: 1-by-2 array of the frequency band for the square window.
%
% OUTPUTS:
% out: n-by-1 window

oneside = ceil(N/2);

out = ones(oneside,1)*.01;
band = floor(band.*N/2);
out(band(1):band(2)) = hamming(band(2)-band(1)+1);

if rem(N,2)>0
    out = cat(1,out,flipud(out(1:oneside-1)));
else
    out = cat(1,out,flipud(out));
end