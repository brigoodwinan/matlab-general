function norms = surfnorms_at_nodes(v,f)
% surfnorms_at_nodes.m
%
% norms = surfnorms_at_nodes(v,f)
%
% Brian Goodwin
%
% 2013-06-16
%
% Calculates surface normals at the nodes instead of at faces.
%
% This function requires the iso2mesh toolbox.

snorm = surfnorm(v,f);

s = map_data2node(f,snorm);

norms = s./(repmat(sqrt(sum(s.^2,2)),1,3));
return