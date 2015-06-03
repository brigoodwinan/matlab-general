function [out,I] = getSizeOfGmmClusts(idx)
% out = getSizeOfGmmClusts(idx)
% [out,I] = getSizeOfGmmClusts(idx)
%
% Brian Goodwin 2015-06-02
%
% Input the group indices (`idx`) and the output is a vector array where
% each entry is the size of the corresponding group; i.e., out(i) contains
% an integer corresponding to the size of group i.
%
% INPUTS:
% idx: n-by-1 array of the group indices as would be acquired from:
%     >> GMModel = fitgmdist(data,numClusters);
%     >> idx = cluster(GMModel,data);
%
% OUTPUTS:
% out: numClusters-by-1 array of the sizes of each group. out(i) is the
%     size of group i.
% I: numClusters-by-1 cell array where each cell entry contains a n-by-1
%     logical array for logical indexing. data(I{1},:) would be the data
%     belonging to cluster number 1 of the GMM.

grps = sort(unique(idx));

out = zeros(max(grps),1);
I = cell(max(grps),1);
for k = grps.'
    I{k} = idx==k;
    out(k) = sum(I{k});
end
return