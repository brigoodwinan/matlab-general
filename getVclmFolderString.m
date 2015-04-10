function out = getVclmFolderString(value)
% out = getVclmFolderString(value)
%
% Brian Goodwin, 2015-03-16
%
% retreives folder string based on folder naming system on Brian's mac.
%
% e.g., out = 'VCLM090'
out = ['VCLM',num2str(value,'%03.0f')];