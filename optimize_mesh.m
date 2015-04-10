function newtet = optimize_mesh(tet)
% newtet = optimize_mesh(tet)
% 
% Brian Goodwin 2014-05-22
%
% Uses tetgen's mesh optimization tool.
%
% This requires Iso2Mesh toolbox to run.
%
% ---------------------------------
% INPUTS
% tet: a stucture with the following fields:
%        *.node: n x 3 points in space
%        *.cell: n x 4 tetrahedron connections
%        *.face: n x 3 face connections (boundary faces or interior faces).
%        *.data: n x 1 domain IDs
% remove: logical indices of the vertices to be removed (n-by-1)
%            1: remove vertices
%            0: keep vertices
%
%            e.g. Indices can be selected based on the growthrates() or
%            meshquality() function.
% OUTPUTS:
% newtet: a structure containing the same structures as in the input mesh
%        having the adaptive paramaters applied.

exesuff = getexeext;
exesuff = fallbackexeext(exesuff,'tetgen');

deletemeshfile(mwpath('meshopt.1*'));

write_node_ele_tetgen(tet.node,cat(2,tet.cell,tet.data),'meshopt');

system([' "',mcpath('tetgen'),exesuff,'" -O3/7',' "',mwpath('meshopt'),'"']);

[newtet.node,newtet.cell,newtet.face] = readtetgen_bdg(mwpath('meshopt.1'));