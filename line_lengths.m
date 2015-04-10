function [L,no,data] = line_lengths(node,edge)
% L = line_lengths(node,edge)
% [L,no] = line_lengths(node,edge)
% [L,no,data] = line_lengths(node,edge)
%
% Brian Goodwin 2014-06-20
%
% When given an edge field (possibly discontinuous), the lengths of the
% lines are given in order of their appearence in the edge field.
%
% This was originally written for dealing with tractography lines from
% TENDFIBER in SCIRun. As a result, the "edge" file must have the form:
%
% edge(:,1) = [1:N-1,N+1:M-1,M+1:P-1, ...]
% edge(:,2) = [2:N, N+2:M, M+2:P, ...]
%
% INPUT:
% node: m-by-3 column vector of nodes
% edge: n-by-2 column vector of edge connections (in the aforementioned
%          form)
%
% OUTPUT:
% L: column vector (N-by-1) containing the lengths of the lines given in
%          the order of the lines as they appear in the edge field.
% no: (optional) number of lines in the edge field or number of times that
%          continuous edges occur.
% data: (optional) an n-by-1 vector containing line identities for the edge
%          field. Each edge is given an identity that is the same as those
%          it forms a line with (is continuous with).
%
% NOTE:
% If you are getting errors, it is likely you need to remove isolated nodes
% from the edge field using "removeisolatednode()" from the Iso2Mesh
% toolbox.

[no,data] = count_lines(edge);
if isPoolOpen
    L = cell(no,1);
    parfor k = 1:no
        tmp = data==k;
        L{k} = sum(sqrt(sum((node(edge(tmp,2),:)-node(edge(tmp,1),:)).^2,2)));
    end
    L = cell2mat(L);
    return
else
    for k = 1:no
        tmp = data==k;
        L(k) = sum(sqrt(sum((node(edge(tmp,2),:)-node(edge(tmp,1),:)).^2,2)));
    end
end