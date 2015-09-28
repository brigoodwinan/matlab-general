function mech = readCSVWithOneHeader(filename,savematfile)
%
% dat = readWIAManCSVFile(filename)
% [dat,headings] = readWIAManCSVFile(filename)
% [dat,headings] = readWIAManCSVFile(filename,savematfile)
%
% Brian Goodwin, 2015-02-19
%
% Reads files that typically are named something like...
% '08-003 unfiltered data...csv'.
%
% INPUTS:
% filename: full path (string) of filename (just drag and drop the filename
%     into the workspace.
% savematfile: name of *mat file to be saved. Automatically saved to the
%     folder it came from.
%
% OUTPUTS:
% mech: structure where *.x is the data and *.head are the headers.

fid = fopen(filename,'r');
headings = fgetl(fid);
headings = textscan(headings,'%s','Delimiter',',');
headings = headings{1}(2:end);
n = length(headings)+1;
dat = textscan(fid,'%f','Delimiter',',');
m = numel(dat{1})/n;
dat = reshape(dat{1},n,m).';
fclose(fid);

mech.x = dat;
mech.head = headings;
uniqheads = unique(mech.head);
n = length(uniqheads);
if length(mech.head)>n
    for k = 1:n
        chg = findCellsThatHaveMatchingString(mech.head,uniqheads{k});
        m = length(chg);
        if m>1
            for i = 1:m
                mech.head{chg(i)} = cat(2,mech.head{chg(i)},' - ',num2str(i));
            end
        end
    end
end

if nargin>1
    [pathstr,~,~] = fileparts(filename);
    save(fullfile(pathstr,savematfile),'mech');
else
    [pathstr,name,ext] = fileparts(filename);
    save(fullfile(pathstr,[name(1:4),'data.mat']),'mech');
end
