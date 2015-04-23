function [out,N] = divideSignalIntoWindows(inSig,n,overlap)
% out = divideSignalIntoWindows(inSig,n,overlap)
% [out,N_new] = divideSignalIntoWindows(inSig,n,overlap)
%
% Brian Goodwin 2015-04-22
%
% Given the size of the window (n) and the amount of overlap (overlap), the
% output is a concatenation of the signal into the specified windows. For
% example, the output will be n-by-m where n is the window length and m is
% the number of possible windows that the signal (inSig) can contain.
%
% INPUT:
% inSig: N-by-1 input signal
% n: size of the window (integer)
% overlap: size of the window overlap. 
%      - If an integer (1 >= overlap > n), the windows overlap the 
%           specified number of points.
%      - If a decimal (0 >= overlap > 1), the windows overlap the specified
%           fraction of the window.
%
% OUTPUT:
% out: n-by-m matrix of the signal into respective windows. m is the
%      maximum number of windows within the signal.
% N_new: (optional) length of the signal that was divided into windows due
%      to rounding

% % Debugging
% inSig = randn(100,1);
% n = 23;
% overlap = .75;
% 

N = length(inSig);

if overlap>=n
    error('Window overlap must be less than the window size.')
end
if overlap<1
    if overlap<0
        error('Window overlap must be a positive value.')
    end
    overlap = fix(n*overlap);
end

nit = floor((N-overlap)./(n-overlap))-1;
N = nit*(n-overlap)+overlap;

iterations = round((0:nit-1)*(n-overlap)+1);
out = [];
for k = iterations
    out = cat(2,out,inSig(k:n+k-1));
end