function I = computeTimeOffset(a)
% I = computeTimeOffset(a)
%
% Brian Goodwin 2016-11-18
%
% Computes the time offset given a response signal (typically
% acceleration). The response signal can either be n-by-1 or n-by-3.
%
% Outputs the index at which t0 should be set so that 
% t_new = t_original-t_original(I);
%
% INPUTS:
% a: n-by-1 or n-by-3 resposne signal.
%
% OUTPUTS:
% I: the index (integer) at which t=0 should be.
%
% NOTE: Needs to inlcude new advancement where once it finds the t=0, to
% then try to go backwards and find the nearest point that is closest to 0.

% compute t-offset
% a = sum(a,2);
avar = log10(movingVariance(a,200));
logind = ~(isnan(avar)|isinf(avar));
tmp = avar(logind);
avar = bsxfun(@minus,avar,getSignalBaseline(tmp(1:fix(size(tmp,1)*.1))));
I = find(max(avar)*.5<avar,1,'first');
