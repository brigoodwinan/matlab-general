function [out,I] = divideSignalIntoWindows(inSig,n,overlap)
% out = divideSignalIntoWindows(inSig,n,overlap)
% [out,I] = divideSignalIntoWindows(inSig,n,overlap)
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
% I: (optional) n-by-m matrix where each entry denotes the index of the
%      point from the signal (INT32 integer). i.e., out = inSig(I);

% % Debugging
% inSig = randn(100,1);
% n = 23;
% overlap = .75;
%

Nsig = uint32(length(inSig));

if overlap>=n
    error('Window overlap must be less than the window size.')
elseif overlap<0
    error('Window overlap must be a positive value.')
elseif overlap<1
    overlap = fix(n*overlap)-1;
end

overlap = uint32(overlap);
n = uint32(n);

nWins = (Nsig-overlap)./(n-overlap)-1;

N = nWins*(n-overlap)+overlap;
out = zeros(n,nWins);

% Optimize efficiency of the script
if nWins<n
    iterations = (0:nWins-1)*(n-overlap)+1;
    for k = 1:nWins
        out(:,k) = inSig(iterations(k):n+iterations(k)-1);
    end
else
    gap = n-overlap;
    for k = 1:n
        out(k,:) = inSig(k:gap:nWins*gap+(k-1));
    end
end

if nargout>1
    if N<=intmax('uint16')
        I = uint16(1:Nsig).';
    elseif N<=intmax('uint32')
        I = uint32(1:Nsig).';
    else
        I = uint64(1:Nsig).';
    end
    I = divideSignalIntoWindows(I,n,overlap);
end
