function cp = crossSingletonExpansion(a,b)
% cp = crossSingletonExpansion(a,b)
%
% Brian Goodwin 2016-11-18
%
% Performs cross product between a and b using singleton expansion; i.e.,
% using bsxfun. This allows for the cross product to be computed without
% repeating a matrix to appease the requirements for the cross() function.
%
% INPUTS:
% a: an n-by-3 or 1-by-3 column vector
% b: an n-by-3 or 1-by-3 column vector

cp = bsxfun(@times,a(:,[2,3,1]),b(:,[3,1,2]));
cp = cp-bsxfun(@times,b(:,[2,3,1]),a(:,[3,1,2]));
return