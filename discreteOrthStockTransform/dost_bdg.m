function [dc,new_sig,new_t] = dost_bdg(sig,t,windowSize,windowOverlap)
% [dc,new_sig,new_t] = dost_bdg(sig,t,windowSize,windowOverlap)
%
% Brian Goodwin 2015-04-02
%
% This utilizes the "dost" function with the purpose of conserving memory.
%
% INPUTS:
% sig: n-by-1 signal
% t: n-by-1 time stamps
% windowSize: (optional) size of window (integer) (default: 5000)
% windowOverlap: (optional) window overlap when computing the stran
%      (default: 0.5)
%
% OUTPUTS:
% dc: discrete orthonormal time-frequency data for the signal.
% new_sig: the new signal after truncation to line up with sxfm.
% new_t: the new time stamps after truncation.

n = length(sig);

if isrow(sig)
    sig = sig.';
end

if nargin<4
    windowOverlap = .5;
    if nargin<3
        windowSize = 4096;
    else
        windowSize = pow2(nextpow2(windowSize));
    end
end

windowOverlap = fix(windowSize*windowOverlap);
windowOverlap = windowOverlap/windowSize; % ensure overlap gives integer
keepValuesInWindow = fix(windowSize*windowOverlap/2)+1:fix(windowSize*(1-windowOverlap/2));

nit = floor(n./(windowSize*(1-windowOverlap)))-1;
n = nit*(windowSize*(1-windowOverlap))+windowSize*windowOverlap;

dc = [];

iterations = round((0:nit-1)*windowSize*(1-windowOverlap)+1);

for k = iterations
    s = dostMatrix(sig(k:windowSize+k-1));
    % s = stran(sig(k:windowSize+k-1));
    dc = cat(2,dc,s(:,keepValuesInWindow));
end

newInd = keepValuesInWindow(1):n-(windowSize-keepValuesInWindow(end));

new_sig = sig(newInd);
new_t = t(newInd);