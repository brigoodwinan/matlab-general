function mech = readWIAManCSVFile(filename,savematfile)
%
% mech = readWIAManCSVFile(filename)
% mech = readWIAManCSVFile(filename,savematfile)
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
%     If savematfile == 0, then no file is saved.
%     i.e., >> dat = readWIAManCSVFile('filename',false);
%
% OUTPUTS:
% mech: structure where *.x is the data, *.head are the headers, and *.ID 
%     is the test ID number.
%
%
% EDITS:
% 2016-02-18: changed file so that 'time' is included in the header. At
%     first the "time" header was simply neglected.

fid = fopen(filename,'r');
one = fgetl(fid);
k = regexpi(one,'WC07A','end');
k = k(1);
mech.ID = str2double(one(k+1:k+4));
fgetl(fid);
headings = fgetl(fid);
headings = textscan(headings,'%s','Delimiter',',');
headings = headings{1}(2:end);
n = length(headings)+1;
directs = fgetl(fid);
directs = textscan(directs,'%s','Delimiter',',');
directs = directs{1}(2:end);
for k = 1:length(directs)
    headings{k} = cat(2,headings{k},' ',directs{k});
end
dat = textscan(fid,'%f','Headerlines',4,'Delimiter',',');
m = numel(dat{1})/n;
dat = reshape(dat{1},n,m).';
fclose(fid);

mech.x = dat;
mech.head = ['Time';headings];
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
    if ~logical(savematfile)
        return
    end
end

if nargin>1
    [pathstr,strname] = fileparts(savematfile);
    if isempty(pathstr)
        pathstr = fileparts(filename);
        save(fullfile(pathstr,savematfile),'mech');
    else
        save(fullfile(pathstr,strname),'mech');
    end
else
    [pathstr,name,ext] = fileparts(filename);
    save(fullfile(pathstr,[name(1:4),'data.mat']),'mech');
end
