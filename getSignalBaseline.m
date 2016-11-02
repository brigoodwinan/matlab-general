function out = getSignalBaseline(in)
% out = getSignalBaseline(in)
%
% Brian Goodwin 2016-08-29
%
% Outputs the baseline of signals in column vector form n-by-m where m is
% the number of signals for which the baseline is computed. The baseline
% output is a row array (or a scalar value for n-by-1 column vector).
%
% To show partiality to the beginning of the signal, run the function
% using:
% >> out = getSignalBaseline(in(1:fix(size(in,1)/2)));
%
% INPUT:
% in: input signal in n-by-m where m is the number of signals. For 1
%     signal, in is n-by-1.
%
% OUTPUT:
% out: row vector of baselines

m = size(in,2);
out = zeros(1,m);
for k = 1:m
    [n,edges] = histcounts(in(:,k));
    [~,I] = max(n);
    out(k) = mean(in(in(:,k)>=edges(I) & in(:,k)<=edges(I+1),k));
end