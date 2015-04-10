function V = edotds(x,e)
% V = edotds(x,e)
%
% Given and electric field on nodes, the voltage is given as output. Nodes
% must be arranged from first to last in order. Must be a continuous line.
%
% INPUTS:
% x: x y and z coordinates n-by-3
% e: electric field vector n-by-3
%
% OUTPUTS:
% V: voltage at each node. the first node is made to be 0V.

V = cat(1,0,cumsum(dot(diff(x,1,1),e(1:end-1,:),2)));
return