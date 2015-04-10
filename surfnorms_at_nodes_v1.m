function norms = surfnorms_at_nodes(v,f)
% surfnorms_at_nodes.m
%
% norms = surfnorms_at_nodes(v,f)
%
% Brian Goodwin
%
% 2013-06-16
%
% Calculates surface normals at the nodes instead of at faces. This
% function requires the iso2mesh toolbox.

snorm = surfnorm(v,f);
n = size(f,1);
m = size(v,1);
j = repmat((1:n)',1,3);
sx = sparse(f,j,repmat(snorm(:,1),1,3),m,n);
sy = sparse(f,j,repmat(snorm(:,2),1,3),m,n);
sz = sparse(f,j,repmat(snorm(:,3),1,3),m,n);

s = full(cat(2,sum(sx,2),sum(sy,2),sum(sz,2)));
norms = s./(repmat(sqrt(sum(s.^2,2)),1,3));
return