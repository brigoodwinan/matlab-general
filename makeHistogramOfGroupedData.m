function [bincent,edges] = makeHistogramOfGroupedData(data,ids,m)
% makeHistogramOfGroupedData(data,ids,m)
% bin_centers = makeHistogramOfGroupedData(data,ids,m)
% [bincent,edges] = makeHistogramOfGroupedData(data,ids,m)
%
% Plots a histogram of data where the bars are colored according to their
% group ids.
%
% Brian Goodwin 2016-04-14
%
% INPUTS:
% data: vector of data point (n-by-1 or 1-by-n)
% ids: group id number for each data point (e.g., from using kmeans).
% m: number of bins for the dataset.

IDs = unique(ids);
% sums = zeros(numel(IDs),1);
%
% for k = IDs'
%     sum(k) = sum(ids==k);
% end
%
% [~,I] = sort(sum,'descend');
% IDs = IDs(I);

[~,edges] = histcounts(data,m);
bincent = edges(1:m)+diff(edges)/2;
n = numel(IDs);
N = zeros(m,n);
for k = 1:n
    N(:,k) = histcounts(data(ids==IDs(k)),edges);
end

% Use barPlot
bar(bincent,N)
