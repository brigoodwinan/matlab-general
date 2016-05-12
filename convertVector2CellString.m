function out = convertVector2CellString(in,strSet)
% out = convertVector2CellString(in)
% out = convertVector2CellString(in,strSet)
%
% Brian Goodwin 2016-05-10
%
% Converts a numeric vector into a cell structure of strings.
%
% INPUTS:
% in: vector.
% strSet: a string that identifies the string format as used in
%      num2str(X,strSet)
%
% OUTPUTS:
% out: cell structure of strings.
tmp = cell(size(in));
if nargin<2
    strSet = {'%f'};
    tmp(:) = strSet;
    strSet = tmp;
else
    tmp(:) = {strSet};
    strSet = tmp;
end

out = cellfun(@(x,y)num2str(x,y),num2cell(in),strSet,'UniformOutput',false);