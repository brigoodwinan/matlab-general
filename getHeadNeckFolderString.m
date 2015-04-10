function out = getHeadNeckFolderString(value)
% out = getHeadNeckFolderString(value)
%
% Brian Goodwin, 2015-03-16
%
% retreives folder string based on folder naming system on Brian's mac.
%
% e.g., out = 'set090'
out = ['set',num2str(value,'%03.0f')];