function IDs = get_connected_edges(edge)
% IDs = get_connected_edges(edge)
%
% Brian Goodwin
%
% 2014-05-15
%
% Takes an edge field and returns the end node indices of all edges. If 
% there are no discontinuities, then ind will be returned empty (e.g. if a
% triange were to be given as an input:
%
% edge = [
%   1 2
%   2 3
%   3 1
% ];
%
% "IDs" would return empty.
%
% INPUTS:
% edge: edge field (n x 2)
%
% OUTPUTS:
% IDs: cell array where each entry contains isolated edges

% f is arbitrary nomenclature.
f = sort(edge,2);
f = sortrows(f);

id = f(1,1); % This needs to be changed to adapt to the new objective

% The following code was adapted from get_connected_faces()

IDs = f(:,1)==id|f(:,2)==id;
while sum(IDs)<num % this needs to be changed so that it finds all interconnected nodes.
    tmp = IDs;
    ids = reshape(unique(f(IDs,:)),1,[]);
    n = length(ids);
    ids = repmat(ids,N,1);
    logic = repmat(f(:,1),1,n)==ids|repmat(f(:,2),1,n)==ids;
    IDs = any(logic,2);
end
temp = (1:N)';
fin = tmp~=IDs;
fin = temp(fin);
fin = fin(1:(sum(IDs)-num));
IDs(fin) = false;
faces = f(IDs,:);
IDs = temp(IDs);