function [A,elem] = calculate_surface_area(v,f)
% A = calculate_surface_area(v,f)
% [A,elem_area] = calculate_surface_area(v,f)
%
% Brian Goodwin
%
% 2013-08-30 - v1
%
% Calculates the surface area of a triangular
% surface mesh.
%
% INPUT:
% v == mesh vertices (nodes) (nx3)
% f == mesh faces (1-based connectors) (nx3)
%
% OUTPUT:
% A == single value of the total surface area
% elem_area == column vector of the surface area
%              of each individual element
%
% See http://en.wikipedia.org/wiki/Triangle

ab = v(f(:,2),:)-v(f(:,1),:);
ac = v(f(:,3),:)-v(f(:,1),:);

temp = sqrt(sum((.5*cross(ab,ac)).^2,2));
A = sum(temp);

if nargout==1;
    return
else
    elem = temp;
    return
end

