function out = findCellsThatHaveMatchingString(inCell,varargin)
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
%
% NOTE:
% The following metacharacters match exactly one character from its respective 
% set of characters:  
% 
%  Metacharacter   Meaning
% ---------------  --------------------------------
%             .    Any character
%            []    Any character contained within the brackets
%           [^]    Any character not contained within the brackets
%            \w    A word character [a-z_A-Z0-9]
%            \W    Not a word character [^a-z_A-Z0-9]
%            \d    A digit [0-9]
%            \D    Not a digit [^0-9]
%            \s    Whitespace [ \t\r\n\f\v]
%            \S    Not whitespace [^ \t\r\n\f\v]
% 
% The following metacharacters are used to logically group subexpressions or
% to specify context for a position in the match.  These metacharacters do not
% match any characters in the string:
% 
%  Metacharacter   Meaning
% ---------------  --------------------------------
%           ()     Group subexpression
%            |     Match subexpression before or after the |
%            ^     Match expression at the start of string
%            $     Match expression at the end of string
%           \<     Match expression at the start of a word
%           \>     Match expression at the end of a word
% 
% The following metacharacters specify the number of times the previous
% metacharacter or grouped subexpression may be matched:
% 
%  Metacharacter   Meaning
% ---------------  --------------------------------
%            *     Match zero or more occurrences
%            +     Match one or more occurrences
%            ?     Match zero or one occurrence
%         {n,m}    Match between n and m occurrences
% 
% Characters that are not special metacharacters are all treated literally in
% a match.  To match a character that is a special metacharacter, escape that
% character with a '\'.  For example '.' matches any character, so to match
% a '.' specifically, use '\.' in your pattern.

[n,m] = size(inCell);
out = false(n,m);

tmp = find(cellfun(@ischar,inCell));
inCell = inCell(tmp);
tmpout = ~out(tmp);

for k = 1:length(varargin)
    tmpout = ~cellfun(@isempty,regexpi(inCell,varargin{k})) & tmpout;
end

out(tmp(tmpout)) = true;

out = find(out);

return
end