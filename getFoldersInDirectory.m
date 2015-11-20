function out = getFoldersInDirectory(in)
% out = getFoldersInDirectory('directory')
%
% Outputs a cell structure that contains a list of the folder names within 
% the directory prescribed. If it is called by itself, it assumes that the
% input directory is the current working directory.
%
% NOTE: This removes any folder names that contain any dots in their folder
% name. In other words, this removes '.','..','...','asd.adgg', etc.
%
% This function uses the "dir()" function. See >> help dir for more
% information on how directory names can be specified.
%
% INPUTS:
% in: a string of the input directory.
%
% OUTPUTS:
% out: a cell structure containing the names of all folders in the given
%     directory.

if ~logical(nargin)
    in = '.';
end

out = dir(fullfile(in));

out = out(cell2mat({out.isdir}));
out = {out.name};

if isempty(out)
    return
end

keepf = true(length(out),1);

% The following removes any folder names that contain any dots in their 
% name. In other words, this removes '.','..','...','asd.adgg', etc.
tmp = findCellsThatHaveMatchingString(out,'\.');
keepf(tmp) = false;

out = out(keepf);