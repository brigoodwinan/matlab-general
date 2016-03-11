function out = movingVariance(in,lag)
% out = movingVariance(in,lag)
%
% Brian Goodwin 2016-03-10
%
% Computes the moving variance given a lag. The algorithm for computing the
% moving variance of a signal with a 1000 (lag) point moving variance is:
%
% lag = 1000;
% mu = filter(ones(lag,1)./lag,1,in);
% out = filter(ones(lag,1)./lag,1,(in-mu).^2);

mu = filter(ones(lag,1)./lag,1,in);
out = filter(ones(lag,1)./lag,1,(in-mu).^2);