function out = tetvol(v,e)
% volume = tetvol(v,e)
%
% Brian Goodwin 2014-07-12
%
% Calculates the volume of each tetrahedron in a mesh.
%
% INPUTS:
% v: mesh vertices (n-by-3).
% e: mesh tetrahedral connections (m-by-4).
%
% OUTPUT:
% volume: the volume of each tetrahedron in the mesh (m-by-1)

if size(e,2)>4
    e = e(:,1:4);
end

out = abs(dot((v(e(:,1),:)-v(e(:,4),:)),cross((v(e(:,2),:)-v(e(:,4),:)),(v(e(:,3),:)-v(e(:,4),:)),2),2))./6;