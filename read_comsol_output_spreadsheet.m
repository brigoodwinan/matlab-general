function c = read_comsol_output_spreadsheet(fname)
% read_comsol_output_spreadsheet.m
%
% Goodwin, Brian,2012-03-02
%
% Reads exported data from COMSOL that has been exported in sectionwise
% format as a *.txt file.
%
% 2013-08-21 - v2 (working version)
%
% VERSION NOTES
%
% v2
% Turned file into function where the filename is given as an input.

% [filename,pathname,filterindex]=uigetfile('*.txt');
% fid=fopen([pathname,filename],'r');
fid=fopen(fname,'r');
% columns=input('Number of columns in the file: ');

fgetl(fid);
fgetl(fid);
fgetl(fid);
out.dim=fgetl(fid);
out.dim=str2double(out.dim(23:end));
out.numnodes=fgetl(fid);
out.numnodes=str2double(out.numnodes(23:end));
out.expressions=fgetl(fid);
out.expressions=str2double(out.expressions(23:end));

% fgetl(fid);
% fgetl(fid);
% out.coords=fscanf(fid,'%f %f %f',[out.dim,out.numnodes])';
fgetl(fid);
fgetl(fid);
col=[];
for i=1:out.dim+out.expressions
    col=[col,' %f'];
end
col=[col,'\n'];

c=textscan(fid,col,'CommentStyle','%');

%save comsolout_cond_16 c
%disp 'Output saved as "comsolout.mat" with cell "c"'