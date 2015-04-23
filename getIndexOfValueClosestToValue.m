function out = getIndexOfValueClosestToValue(x,value)
% out = getIndexOfValueClosestToValue(x,value)
%
% Brian Goodwin 2015-03-17
%
% Given a value and a vector/array, the index in "x" is found that has the
% value closest to "value."
%
% e.g.
% x = 1:.021234:17;
% value = 5;
% ind = getIndexOfValueClosestToValue(x,value);
%
% INPUT:
% x: array or vector (n-by-1)
% value: a double, int, or whatever. Can be an array or vector.
%
% OUTPUT:
% out: index of "x" variable that contains a value closest to "value."
l = length(value);
if l>1
    out = zeros(l,1);
    for k = 1:l
        [~,out(k)] = min(abs(x-value(k)));
    end
else
    [~,out] = min(abs(x-value));
end
return