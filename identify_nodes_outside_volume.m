function indices=identify_nodes_outside_volume(v,f,nodes)
% indices = identify_nodes_outside_volume(v,f,nodes)
%
% Brian Goodwin
%
% Edit Dates:
% 2013-06-17 --- v1 ---
%
% v = nodes of surface containing volume (nx3)
% f = faces (nx3)
% nodes = nodes to test if are contained in closed surface (nx3)
%
% output:
% indices - a logical array identifying nodes outside of closed surface
%   i.e. 1 == nodes outside the closed surface
%        0 == nodes inside the closed surface
%
% Note that for this to work effectively, there cannot be any nodes that
% are displaced outside the surface >0.1*width of the closed surface.
n=length(nodes);
vs=cat(1,v,nodes);
mn=min(vs);
mx=max(vs);

ds=min(mx-mn)*0.01;

xi=(mn(1)-ds):ds:(mx(1)+ds);
yi=(mn(2)-ds):ds:(mx(2)+ds);
zi=(mn(3)-ds):ds:(mx(3)+ds);

img=surf2vol(v,f,xi,yi,zi);

nodes=ceil((nodes-repmat([xi(1),yi(1),zi(1)],n,1))/ds);
% nodes=unique(nodes,'rows');

indices=zeros(n,1);
for k=1:n
    indices(k)=~img(nodes(k,1),nodes(k,2),nodes(k,3));
end