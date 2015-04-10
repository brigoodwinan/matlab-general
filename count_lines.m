function [no,data] = count_lines(edge)
% NumLines = count_lines(edge)
% [NumLines,data] = count_lines(edge)
%
% 2014-02-26 Brian Goodwin
%
% Input the edge vector of the curve field (or streamlines, fibers, etc.)
% that contains the connections for nodes. The output will be the number of
% lines in the field.
%
% Each node in the field must lie only on one (1) line.
%
% This was originally written for dealing with tractography lines from
% TENDFIBER in SCIRun. As a result, the "edge" file must have the form:
%
% edge(:,1) = [1:N-1,N+1:M-1,M+1:P-1, ...]
% edge(:,2) = [2:N, N+2:M, M+2:P, ...]
%
% INPUT:
% edge: Nx2 vector of connections (contains the connections between each
%          node).
%
% OUTPUT:
% NumLines: single quantity equal to the number of lines in the field.
% data: (optional) an n-by-1 vector containing line identities for the edge
%          field. Each edge is given an identity that is the same as those
%          it forms a line with (is continuous with).
%
% NOTE: 
% If you are getting errors, it is likely you need to remove isolated nodes
% from the edge field using "removeisolatednode()" from the Iso2Mesh
% toolbox.

N = size(edge,1);
if N==1
    no = 1;
    data = 1;
    return
end
edge = sort(reshape(double(edge),[],1));
edge = edge(2:end)-edge(1:end-1);

tmp = cat(1,1,edge(2:2:end));

no = sum(tmp);
if nargout>1
    if no<intmax('uint16')
        data = uint16(zeros(N,1));
    else
        data = zeros(N,1);
    end
    tmp = cat(1,logical(tmp),true);
    tmp = find(tmp);
    for k = 1:no
        data(tmp(k):tmp(k+1)-1) = k;
    end
end
return