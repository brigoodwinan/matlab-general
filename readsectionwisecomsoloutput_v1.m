% readsectionwisecomsoloutput.m
%
% Goodwin,Brian,2012-03-02
%
% Reads exported data from COMSOL that has been exported in sectionwise
% format as a *.txt file.

[filename,pathname,filterindex]=uigetfile('*.txt');
fid=fopen([pathname,filename],'r');

elemdim=4; % this needs to be set by the user every time. For trisurf, this should be "3"

fgetl(fid);
fgetl(fid);
fgetl(fid);
out.dim=fgetl(fid);
out.dim=str2double(out.dim(23:end));
out.numnodes=fgetl(fid);
out.numnodes=str2double(out.numnodes(23:end));
out.numelem=fgetl(fid);
out.numelem=str2double(out.numelem(23:end));
out.expressions=fgetl(fid);
out.expressions=str2double(out.expressions(23:end));

fgetl(fid);
fgetl(fid);
out.coords=fscanf(fid,'%f %f %f',[out.dim,out.numnodes])';
fgetl(fid);
fgetl(fid);
out.elem=fscanf(fid,'%f %f %f %f',[elemdim,out.numelem])';

for k=1:out.expressions
    fgetl(fid);
    varname=fgetl(fid);
    col=find(varname=='('|varname==')');
    varname=varname(col(1)+1:col(2)-1);
    temp=textscan(fid,'%f',out.numnodes);    
    eval([varname,'= temp{1};']);
end

%save comsolout
%disp 'Output saved as "comsolout_cond_1.mat"'