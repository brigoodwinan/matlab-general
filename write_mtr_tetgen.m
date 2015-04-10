function write_mtr_tetgen(value,filename)
% write_mtr_tetgen(value,filename)
%
% Brian Goodwin 2014-05-23
%
% Writes *.mtr file for tetgen.
%
% First line: <# of nodes> <size of metric (always 1)>
%   Remaining lines list # of point metrics:
%     <value> 
%     ...
%
% Requires the iso2mesh toolbox to run.
%
% INPUTS
% value: numerical values to be applied in mtr file. ([# of nodes] x 1)
% filename: a string without a file extension (e.g. 'tetgenmesh')
%       Also, if the desire is to make a "background" mesh for mesh sizing
%       and refinement (*.b.mtr), include the subextension
%       within the filename (e.g. 'tetgenmesh.b')
n = length(value);
fid = fopen(mwpath([filename,'.mtr']),'w');
fprintf(fid,'%i %i\n',[n,1]);
fprintf(fid,'%.6f\n',value);
fclose(fid);