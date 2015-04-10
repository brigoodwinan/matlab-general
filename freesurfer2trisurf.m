% freesurfer2trisurf.m
%
% Reads rh.pial or lh.pial surface from freesurfer and
% writes it to a SciRun file *.pts and *.fac

% Example:  read:   lh.pial 
%          write:   lh.pial.pts and lh.pial.fac

% KD March/2010

% clear all; clc; close all;
 
% read file
curdir=cd;

[filename,pathname]=uigetfile({'*.*'},'Pick FreeSurfer Surface File');
[verts,faces] = readsurface([pathname,filename]);
% Faces are 1-based indexing from readsurface commmand. 

%% write file
fid=fopen([curdir,'/',filename,'.pts'],'w');
fprintf(fid,'%12.8f %12.8f %12.8f\n',verts');
fclose(fid);

fid=fopen([curdir,'/',filename,'.fac'],'w');
fprintf(fid,'%i %i %i\n',faces');
fclose(fid);

disp('done!')