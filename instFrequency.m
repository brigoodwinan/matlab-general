function out = instFrequency(sig)
% out = instFrequency(sig)
%
% Brian Goodwin, 2015-04-16
%
% Uses the hilbert transform to compute the "instantaneous frequency."
%
% INPUT:
% sig: n-by-1 input signal (or the first non-singleton dimension). For
%     n-by-m inputs, computes the 1D instantaneous frequency along the 
%     columns.

[n,m] = size(sig);
if m>1 && n==1
    sig = sig.';
end
    
%{
Hd = makeDifferentiator(50);
g = grpdelay(Hd,3);
out = filter(Hd.Numerator,1,unwrap(angle(hilbert(sig))))/2*pi; % normalized frequency
out = circshift(out,g);
%}

out = diff(unwrap(angle(hilbert(sig))))/2*pi; % normalized frequency
[b,a] = butter(4,.1);
out = filtfilt(b,a,out);