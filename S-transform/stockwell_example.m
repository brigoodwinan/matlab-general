% stran_test.m
%
% Brian Goodwin
%
% An example for implementing the stockwell transform code

load mtlb % mtlb, Fs
h = repmat(mtlb,2,1);
N = size(h,1);

if ~isPoolOpen
    gcp
end

S = stockwell(h);

makeTimeFreqPlot(S,1/Fs,h)