function nodes = get_connected_nodes(ele,id,num)
% nodes = get_connected_nodes(ele,id,num)
%
% Brian Goodwin
%
% Editing dates:
% 2013-06-06 --- v1 ---
%
% Retrieves the IDs of first [num] closest connected nodes in
% a mesh (edge, face, or tet).
%
% INPUTS:
% ele  == mesh connections.
% id   == node ID to find the closest connected nodes.
% num  == number of closest connected nodes to retrieve.
%
% OUTPUT:
% nodes == the IDs of the closest connected nodes to the node
%            "id." (num-by-1)
%
% This file was originally created for use in the CORTICAL_MODEL.

nodes = id;
while numel(nodes)<num
    ids = [];
    for k = id'
        [I,~] = find(ele==k);
        temp = ele(I,:);
        temp = reshape(temp,numel(temp),1);
        ids = unique(cat(1,ids,temp));
    end
    nodes = unique(cat(1,nodes,ids));
    id = ids;
end
nodes = nodes(1:num);
return