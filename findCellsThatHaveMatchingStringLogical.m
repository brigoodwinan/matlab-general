function out = findCellsThatHaveMatchingStringLogical(inCell,varargin)
% IDs = findCellsThatHaveMatchingString(cellOfStrings,string1,string2,...,stringN)
%
% Brian Goodwin 2015-06-26
%
% Given a cell structure where each cell is a string and any number of
% string patters, this function will output the cell indices that contain
% matches of all specified strings.
%
% Uses the regexpi() function.
%
% INPUT:
% cellOfStrings: a cell structure where each cell contains a string. e.g.
%      {'blah','blah';'blah','blah'}
% string1...N: a string input to find within the cells.
%
% OUTPUT:
% IDs: integers of the cell indices that contained matches of all listed
%      strings.

[n,m] = size(inCell);
out = false(n,m);

tmp = find(cellfun(@ischar,inCell));
inCell = inCell(tmp);
tmpout = ~out(tmp);

for k = 1:length(varargin)
    tmpout = ~cellfun(@isempty,regexpi(inCell,varargin{k})) & tmpout;
end

out(tmp(tmpout)) = true;

return
end