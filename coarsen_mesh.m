function tet = coarsen_mesh(v,ele,maxiter,grtol,qtol)
% newtet = coarsen_mesh(tet,maxiter,grtol,qtol)
% Brian Goodwin 2014-05-22
%
% Coarsens a mesh according to element quality and growth rates. This
% function will aim to remove nodes that contain poor element quality or
% have high growth rates.
%
% It is recommended that you look at histograms of element quality and
% growthrates before choosing a quality tolerance and growth rate
% tolerance.
%
% e.g. Indices can be selected based on the growthrates() or
% meshquality() function.
%
% This requires Iso2Mesh toolbox to run.
%
% ---------------------------------
% INPUTS
% v: Mesh vertices (m-by-3)
% ele: Mesh connections (n-by-4). If you desire to keep the domain numbers,
%        then this should be (n-by-5) where the 5th column contains element
%        identities.
% 
% maxiter: the maximum number of iterations to go through before
%             terminating with less-than-acceptable growth rates and
%             qualities.
%
% grtol: the growth rate tolerance (between 0 and inf). This quality is
%             according to the Joe-Liu method in Iso2Mesh.
% 
% qtol: element quality tolerance (between 0 and 1)
%
% OUTPUTS:
% tet: a stucture with the following fields:
%        *.node: n x 3 points in space
%        *.cell: n x 4 tetrahedron connections
%        *.face: n x 3 face connections (boundary faces or interior faces).
%        *.data: n x 1 domain IDs

q = meshquality_bdg(v,ele,'node');
gr = growthrates(v,ele);

ind = gr>grtol | q<qtol;

iter = 0;
while (min(q)<qtol || max(gr)>grtol) && iter<maxiter
    iter = iter+1;
    
    deletemeshfile(mwpath('meshcoarsen.1.*'));
    
    write_node_ele_tetgen(cat(2,v,-ind),ele,'meshcoarsen');
    
    system(['tetgen -rR -V ',mwpath('meshcoarsen')]);
    
    % read in the generated mesh
    [v,ele,f]=readtetgen_bdg(mwpath('meshcoarsen.1'));
    
    gr = growthrates(v,ele);
    q = meshquality_bdg(v,ele,'node');
end

tet = struct('node',v(:,1:3),'cell',ele(:,1:4),'face',f(:,1:3),'data',ele(:,5));

