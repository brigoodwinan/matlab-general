function data = cat_txt_files(txtstring,arraylen)
% data = cat_txt_files(txtstring)
% data = cat_txt_files(txtstring,arraylen)
%
% Brian Goodwin, 2014-08-04
%
% Concatenates text files into a single data matrix. This script was
% originally made for the purpose of concatenating 1000s of text files that
% contain only a single line numerical array.
%
% e.g.:
% txt file 1: 1234 1.234 2.345
% txt file 2: 5678 5.678 6.789
% data = [
%    1234 1.234 2.345
%    5678 5.678 6.789
% ];
%
% INPUT:
% txtstring: a string containing the filepath and filenames in the
%     following format:
%
%     '/this/is/the/filepath/*ilenam*.txt'
%
%     With this format, all the files have names with the string "ilenam"
%     will be concatenated together. If the files are numbered
%     (filename_#####.txt), the format would be:
%
%     '/this/is/the/filepath/filename_*.txt'
%
% arraylen: (optional) length of numerical array in each text file (default
%     is 3).
%
% OUTPUT:
% data: the concatenated data within the selected text files (see above
%     example).

loc = strfind(txtstring,filesep);
loc = loc(end);
thepath = txtstring(1:loc);
thestring = txtstring(loc+1:end);

filenames = get_files_in_dir(thepath,thestring);

fnlen = length(filenames);
if nargin<2
    arraylen = 3;
end
data = zeros(fnlen,arraylen);
for k = 1:fnlen
    fid = fopen([thepath,filenames{k}],'r');
    tmp = textscan(fid,'%f',arraylen);
	fclose(fid);
    data(k,:) = tmp{1}.';
end