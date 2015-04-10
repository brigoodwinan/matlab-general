function Iu = unsort(Is)
% I = unsort(Is)
%
% Given indices from a sorting function (e.g. "sort.m"), this function will
% provide the indices to convert from the sorted to the original.
%
% e.g.:
% [Xsorted,Is] = sortrows(X); where X(Is)=Xsorted.
% clearvars X
% X = Xsorted(unsort(Is))
%
% INPUT:
% Is: (n-by-1) indices as would be obtained from [Xsorted,Is]=sortrows(X)
%
% OUTPUT:
% Iu: the indices required to revert from the Xsorted to the original X.
%      i.e. Xsorted(Iu)=X

Iu(Is) = (1:length(Is)).';