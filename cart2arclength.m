function s = cart2arclength(x)
% s = cart2arclength(x)
%
% Brian Goodwin, 2014-06-05
%
% Converts a line in 2d or 3d space to the equivalent
% arclength. The line is defined by points in space.
%
% INPUT:
% x: column vector (nx1, nx2, or nx3) of points in 3d
%     space. The point coordinates must be in order.
%     i.e. the edge file would be [1 2; 2 3; 3 4; ...]
%
% OUTPUT:
% s: output vector (nx1) where the first value is 0 and
%     the following 1d points are the equivalent arc
%     length.

s = cumsum(cat(1,0,vectormag(diff(x,1,1))));
return