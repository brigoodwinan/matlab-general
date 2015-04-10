function theta = anglebtwnvectors(a,b)
% theta = anglebtwnvectors(a,b)
% theta = anglebtwnvectors(V)
%
% Brian Goodwin 2014-06-26
%
% Calculates the angle between two 3D vectors in radians. The resulting 
% angle is between 0 and pi. 
%
% INPUTS:
% a: vector 1 (n-by-3)
% b: vector 2 (n-by-3)
% V: [a;b] (2-by-3)
%
% OUTPUT:
% theta: angle between "a" and "b" in radians 0<theta<pi

if nargin==1
	b = a(2,:);
	a = a(1,:);
end

a = bsxfun(@rdivide,a,vectormag(a));
b = bsxfun(@rdivide,b,vectormag(b));

theta = atan2(vectormag(cross(a,b,2)),dot(a,b,2));