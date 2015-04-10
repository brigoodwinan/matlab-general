function newtet = adaptive_mesh(tet,spacepts,minelemsize,maxelemsize,custom)
% newtet = adaptive_mesh(tet,spacepts,minelemsize,maxelemsize)
%
% Brian Goodwin 2014-05-22
%
% Takes an already generated tetrahedral mesh and provides optimization by
% varying the mesh density throughout the mesh. A minimum and maximum edge
% length is specified by the user. The edge length increases linearly from
% the mesh nodes that are closest to "spacepts" to the furthest nodes.
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
%
% spacepts: (n x 3) points in space where the closest mesh nodes (tet.node)
%        closest have the minimum edge length specified and the furthest
%        mesh nodes have the maximum edge length that is specified.
%
% minelemsize: minimum edge length in the mesh
%
% maxelemsize: maximum edge length in the mesh
%
% custom: (optional) specify the order of the increase in mesh density.
%        Default order is 1. i.e. mesh density decreases from the
%        "spacepts" nodes by (R/max(R))^.1
%
% ---------------------------------
% OUTPUTS
% newtet: a structure containing the same structures as in the input mesh
%        having the adaptive paramaters applied.

% % For Debugging.
% [tet.node,tet.face,tet.cell] = meshunitsphere(.1,.1);
% plotmesh(tet.node,tet.face,tet.cell,'x>0');
% tet.data = ones(length(tet.cell),1);
% spacepts = [0 0 1.1]; minelemsize = .2^3; maxelemsize = .75^3;

% n = size(tet.node,1);
if nargin<5
    custom = 1;
end
    
numpts = size(spacepts,1);
sortnodes = zeros(1,numpts);
for k = 1:numpts
    tmp = sqrt(sum(cat(2,tet.node(:,1)-spacepts(k,1),tet.node(:,2)-spacepts(k,2),tet.node(:,3)-spacepts(k,3)).^2,2));
    tmp = tmp-min(tmp);
    tmp = (tmp./max(tmp)).^custom;
    if k>1
        tmplog = sortnodes<tmp;
        sortnodes(tmplog) = sortnodes(tmplog);
        sortnodes(~tmplog) = tmp(~tmplog);
    else
        sortnodes = tmp;
    end
end

elemsize = sortnodes.*(maxelemsize-minelemsize)+minelemsize;

% % Attempted use of removing nodes. - DOES NOT WORK
% q = elemvolume(tet.node,tet.cell).^.3333;
% q = repmat(q,1,4);
% logtmp = any(elemsize(tet.cell)>q,2);
% logtmp = unique(reshape(tet.cell(logtmp,:),[],1));
% 
% bndrymrk = zeros(n,1);
% 
% bndrymrk(logtmp) = -1;
% bndrymrk(unique(reshape(tet.face,[],1))) = 0;

deletemeshfile(mwpath('meshadapt.1.*'));

exesuff=getexeext;
exesuff=fallbackexeext(exesuff,'tetgen');

% Save mesh files.

% write_node_ele_tetgen(tet.node,cat(2,tet.cell,tet.data),'meshadapt.b');
write_node_ele_tetgen(tet.node,tet.cell,'meshadapt.b');
% write_node_ele_tetgen(cat(2,tet.node,bndrymrk),cat(2,tet.cell,tet.data),'meshadapt');
write_node_ele_tetgen(tet.node,cat(2,tet.cell,tet.data),'meshadapt');
write_mtr_tetgen(elemsize,'meshadapt.b');

% Call TETGEN
% May have to look into mesh coarsening (-R switch)
% With -r switch, *.node and *.ele files are required.
% The -m switch needs a background mesh
%
% The mesh element size is defined on the nodes of a background mesh. In 
% this case, there is a background mesh given by the files xxx.b.node, 
% xxx.b.ele, and the mesh element size file xxx.b.mtr.
%
% Test this without mesh reconstruction and with mesh generation (i.e.
% construct a *.poly mesh and apply this to it.
system([' "' mcpath('tetgen') exesuff '" -AqrmR ',' "',mwpath('meshadapt'),'"']);

% read in the generated mesh
[newtet.node,newtet.cell,newtet.face] = readtetgen_bdg(mwpath('meshadapt.1'));
newtet.data = newtet.cell(:,5);
newtet.cell = newtet.cell(:,1:4);
newtet.face = newtet.face(:,1:3);
return
end