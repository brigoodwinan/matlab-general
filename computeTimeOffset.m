function I = computeTimeOffset(a)
% I = computeTimeOffset(a)
%
% Brian Goodwin 2016-11-18
%
% Computes the time offset given a response signal (typically
% acceleration). The response signal can either be n-by-1 or n-by-3.
%
% While this should work for a variety of applications, this function has 
% parameters that have been tested for using with acceleration responses
% for the WIAMan head and neck program.
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
n = size(a,1);
n1 = fix(n/20);
n2 = fix(n/40);
a = bsxfun(@rdivide,a,sum(abs(a)));
avar = log10(movingVariance(a,200));
avar = bsxfun(@minus,avar,getSignalBaseline(avar(1:n1,:)));
avar(isnan(avar)|isinf(avar)) = 0;
avar = prod(avar,2);

% Find first peak
ma1 = ones(n1,1)./n1;
ma2 = ones(n2,1)./n2;
x = filtfilt(ma2,1,avar)-filtfilt(ma1,1,avar);
x(x<=0) = 0;
tmp = diff(x)<0;
tmp = cat(1,tmp,false);
x(~tmp) = 0;
tmp = diff(x)>0;
tmp = cat(1,false,tmp);
x(~tmp) = 0;
p1 = avar(find(x>0.7*max(x),1,'first'));

% OUTPUT:
I = find(p1*.33<avar,1,'first');