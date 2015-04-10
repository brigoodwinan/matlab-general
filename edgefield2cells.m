function [p,id,Ntract] = edgefield2cells(v,e)
% p = edgefield2cells(v,e)
% [p,id] = edgefield2cells(v,e)
% [p,id,NumLines] = edgefield2cells(v,e)
%
% Brian Goodwin 2014-06-25
%
% When given vertices and edges from an edge field, each individual
% continuous edge is placed into its own cell.
%
% This function was originally written for dealing with fiber tracts as
% would come from TENDFIBER network in SCIRun.
%
% INPUTS:
% v: edge field vertices (n-by-3)
% e: edge connections (N-by-2)
%
% OUTPUTS:
% p: a cell structure where each cell contains the verticies of a
%      continuous edge.
% id: (optional) an n-by-1 vector containing line identities for the edge
%      field. Each vertex is given an identity that is the same as those
%      it forms a line with (is continuous with). Identity numbers are
%      integers starting from 1 and increasing.
% NumLines: single quantity equal to the number of lines in the field.
%
% NOTE: 
% If you are getting errors, it is likely you need to remove isolated nodes
% from the edge field using "removeisolatednode()" from the Iso2Mesh
% toolbox.

[Ntract,id] = count_lines(e);
id = map_data2node(e,id);

p = cell(Ntract,1);

if isPoolOpen
    parfor k = 1:Ntract
        p{k} = v(id==k,:);
    end
    return
else
    for k = 1:Ntract
        p{k} = v(id==k,:);
    end
end