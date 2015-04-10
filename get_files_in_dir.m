function cellfiles = get_files_in_dir(direc,ext)
% files = get_files_in_dir(directory)
% files = get_files_in_dir(directory,ext)
%
% Brian Goodwin 2014-07-22
%
% Retrieves files in a given directory. No directories are
% retrieved.
%
% INPUTS:
% directory: string of the directory
% ext: string of a file extension. "files" will only contain
%      the provided extension. This should be entered as:
%      '*.m'
%      '*.mat'
%      '*foo*'
%      '*foo*.m'
%
% OUTPUTS:
% files: cell structure of the files in the directory
%      with the given extension (if provided).

if nargin>1
    tmp = dir([direc,ext]);
    cellfiles = {tmp.name}.';
    return
else
    tmp = dir(direc);
    tmpisdir = cell2mat({tmp.isdir});
    tmp = {tmp.name};
    cellfiles = tmp(~tmpisdir).';
end