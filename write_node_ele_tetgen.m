function write_node_ele_tetgen(node,ele,filename)
% write_node_ele_tetgen(node,ele,filename)
%
% Writes files to iso2mesh tmp directory for tetgen.
%
% INPUTS
% node: n x 3 points in 3D space.
% ele: n x 4 tetrahedron connections. If ele is n x 5, the fifth column is
%       applied as domain IDs.
% filename: a string without a file extension (e.g. 'tetgenmesh')
%       Also, if the desire is to make a "background" mesh for mesh sizing
%       and refinement (*.b.node & *.b.ele), include the subextension
%       within the filename (e.g. 'tetgenmesh.b')
%
% From tetgen website:
%
% node file:
% First line:  <# of points> <dimension (3)> <# of attributes>
%                <boundary markers (0 or 1)>
%   Remaining lines list # of points:
%     <point #> <x> <y> <z> [attributes] [boundary marker]
% 
% ele file:
% First line: <# of tetrahedra> <nodes per tet. (4 or 10)>
%               <region attribute (0 or 1)>
%   Remaining lines list # of tetrahedra:
%     <tetrahedron #> <node> <node> ... <node> [attribute]
%     ...

[n,m] = size(node);
node = cat(2,(1:n)',node);
fid = fopen([mwpath(filename),'.node'],'w');
if m==4
    fprintf(fid,'%i %i %i %i\n',[n,3,0,1]);
    fprintf(fid,'%i %.8E %.8E %.8E %i\n',node');
else
    fprintf(fid,'%i %i %i %i\n',[n,3,0,0]);
    fprintf(fid,'%12i %12.8E %12.8E %12.8E\n',node');
end
fclose(fid);

[n,m] = size(ele);
fid = fopen([mwpath(filename),'.ele'],'w');
if m==5
    ele = cat(2,(1:n).',ele);
    fprintf(fid,'%i %i %i\n',[n,4,1].');
    fprintf(fid,'%i %i %i %i %i %i\n',ele.');
elseif m==4
    fprintf(fid,'%i %i %i\n',[n,4,0]);
    ele = cat(2,(1:n).',ele);
    fprintf(fid,'%i %i %i %i %i\n',ele.');
else
    error('"ele" field must have either 4 or 5 columns')
end
fclose(fid);