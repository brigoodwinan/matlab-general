function [IDs,faces] = get_connected_faces(f,id,num)
% IDs = get_connected_faces(face,id,num)
% [IDs,faces] = get_connected_faces(f,id,num)
%
% Brian Goodwin
%
% Editing dates:
% 2014-03-05 - v1
%
% Retrieves the IDs of first [num] closest connected faces
% given the 1-based indexed face (nn x 3).
%
% INPUTS:
% f == 3-column vector of the trisurf faces.
% id   == node ID to find the closest connected faces.
% num  == number of closest connected faces to retrieve.
%
% OUTPUT:
% IDs == the ID numbers of the faces or simply put, the identity number of
%            the closest [num] faces to the node, "id".
% faces == the face ceonnections of the closest connected faces to the node
%            "id". ([num] x 3 column vector)


N = length(f);
IDs = f(:,1)==id|f(:,2)==id|f(:,3)==id;
while sum(IDs)<num
    tmp = IDs;
    ids = reshape(unique(f(IDs,:)),1,[]);
    n = length(ids);
    ids = repmat(ids,N,1);
    logic = repmat(f(:,1),1,n)==ids|repmat(f(:,2),1,n)==ids|repmat(f(:,3),1,n)==ids;
    IDs = any(logic,2);
end
fin = find(tmp~=IDs);
fin = fin(1:(sum(IDs)-num));
IDs(fin) = false;
faces = f(IDs,:);
IDs = find(IDs);
return