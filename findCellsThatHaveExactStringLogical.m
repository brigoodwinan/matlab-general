function out = findCellsThatHaveExactStringLogical(inCell,inString)
% IDs = findCellsThatHaveExactString(cellOfStrings,string)
%
% Brian Goodwin 2015-06-26
%
% Given a cell structure where each cell is a string and any number of
% string patters, this function will output the cell indices that contain
% exact matches of the specified string.
%
% Uses the regexpi() function.
%
% INPUT:
% cellOfStrings: a cell structure where each cell contains a string. e.g.
%      {'blah','blah';'blah','blah'}
% string: a string input to find within the cells.
%
% OUTPUT:
% IDs: integers of the cell indices that contained matches of all listed
%      strings.

[n,m] = size(inCell);
out = false(n,m);

tmp = find(cellfun(@ischar,inCell));
inCell = inCell(tmp);
tmpout = ~out(tmp);

tmpout = ~cellfun(@isempty,regexpi(inCell,['^',inString,'$'])) & tmpout;

out(tmp(tmpout)) = true;

return
end