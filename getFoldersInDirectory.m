function out = getFoldersInDirectory(in,varargin)
% out = getFoldersInDirectory('directory')
% out = getFoldersInDirectory('directory','string1','string2',...)
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
% string1...N: string inputs. If provided, the output will contain folder
%     names that contain matches with string1 or string2 or string3. Note
%     that it doesn't require that string1 and string2 exist within the
%     folder name, but that string1 or string2 exist within the folder
%     name.
%
% OUTPUTS:
% out: a cell structure containing the names of all folders in the given
%     directory.

if ~logical(nargin)
    in = '.';
end

out = dir(fullfile(in));

out = out([out.isdir]);
out = {out.name}';

if isempty(out)
    return
end

keepf = true(length(out),1);

% The following removes any folder names that contain any dots in their
% name. In other words, this removes '.','..','...','asd.adgg', etc.
tmp = findCellsThatHaveMatchingString(out,'\.');
keepf(tmp) = false;
out = out(keepf);

if ~isempty(varargin)
    keepf = false(length(out),1);
    for k = 1:length(varargin)
        keepf = findCellsThatHaveMatchingStringLogical(out,varargin{k})|keepf;
    end
    out = out(keepf);
end