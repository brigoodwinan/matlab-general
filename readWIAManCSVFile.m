function readWIAManCSVFile(filename,savematfile)
%
% dat = readWIAManCSVFile(filename)
% [dat,headings] = readWIAManCSVFile(filename)
% [dat,headings] = readWIAManCSVFile(filename,savematfile)
%
% Brian Goodwin, 2015-02-19
%
% Reads in Army Man files that typically are named something like...
% '08-003 unfiltered data 03Jul14 10-25-57.csv'.
%
% INPUTS:
% filename: full path (string) of filename (just drag and drop the filename
%     into the workspace. 
% savematfile: name of *mat file to be saved. Automatically saved to the
%     folder it came from.
%
% OUTPUTS:
% dat: data output. The first column is "time"
% headings:

m = csvread(filename,8,1);

dat = m(1:end-4,:);
[nlen,numheads] = size(dat);
m = csvread(filename,8,0,[8,0,8+nlen-1,0]);
dat = cat(2,m,dat);

fid = fopen(filename,'r');
fgetl(fid);
fgetl(fid);
c = textscan(fid,'%s',numheads+1,'Delimiter',',');
headings = c{1}(2:end);

if nargin>1
    mech.x = dat;
    mech.head = headings;
    [pathstr,~,~] = fileparts(filename);
    save(fullfile(pathstr,savematfile),'mech');
else
    mech.x = dat;
    mech.head = headings;
    [pathstr,name,ext] = fileparts(filename);
    save(fullfile(pathstr,[name(1:4),'data.mat']),'mech');
end
