function V = vectormag(v,vv,dim)
% V = vectormag(v)
% V = vectormag(p1,p2)
% V = vectormag(v,[],dim)
%
% Brian Goodwin 2014-06-27
%
% Calculates magnitude of vectors
%
% INPUTS:
% v: n-by-3 column vector of vectors where V = sqrt(sum(v.^2,2))
%
% p1: n-by-3 column vector of points.
% p2: 1-by-3 point where the distance is calculated between points "p1" and
%       point "p2".
% dim: the dimension along which to perform the normalization. (e.g., v is
% n-by-n-by-3 then >> V = vectormag(v,[],3);
%
% OUTPUTS:
% V: n-by-1 column vector of the magnitude (or distance when given p1 and
%       p2).
%
% Note: function also works for N-dimensional data.

if nargin==1
    V = sqrt(sum(v.^2,2));
elseif nargin==2
    V = sqrt(sum(bsxfun(@minus,v,vv).^2,2));
elseif nargin==3
    V = sqrt(sum(v.^2,dim));
else
    error('Too many inputs.')
end