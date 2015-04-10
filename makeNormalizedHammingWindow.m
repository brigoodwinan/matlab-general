function windowHamming = makeNormalizedHammingWindow(L)
% windowHamming = makeOddLengthHammingWindow(L)
%
% Brian Goodwin, 2015-03-17
%
% Given a window length (odd or even length or non-integer), the output 
% will be a normalized hamming window that has an odd length for use in 
% multiplying certain indices around a single point. e.g.:
%
% x = randn(1,100);
% [windowHamming,wH] = makeOddLengthHammingWindow(length(x)/3);
% n = 50;
% someValue = x(n-wH:n+wH)*windowHamming
%
% "someValue" is a weighted average of the points surrounding x(n) using a 
% window length of approximately length(x)/3.
% 
% The hamming window is normalized so that sum(windowHamming) = 1;
%
% OUTPUTS:
% windowHamming: n-by-1 vector of the normalized hamming window.
% windowHalf: an integer of the size of the bottom (and top) half of the
%        window, excluding the middle point. (i.e. floor(n/2))
%
% INPUTS:
% L: window length desired (does not have to be an integer).

windowHamming = hamming(L);
windowHamming = windowHamming./sum(windowHamming);
return