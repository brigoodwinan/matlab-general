function x = removeSpikesFasterThanMinimumISI(x,misi)
% removeSpikesFasterThanMinimumISI.m
%
% Brian Goodwin 2017-01-17
%
% Uses recursion to quickly remove spikes if they violate a minimum ISI
% criteria.
%
% This is also set to add addiitonal variabilty to the misi by increasing
% it between 1x and 2x at random.
% 
% INPUTS:
% x: logical array or single-column vector (n-by-1)
% misi: minimum interspike interval in units of [samples]
%
% OUTPUTS:
% x: the resulting logical array that no longer violates the minumium ISI
%     as specified.

f = find(x);
isi = diff(f);
f = f(2:end);

logind = isi<misi;
if any(logind)
    x(f(find(logind,1,'first'))) = false;
    x = removeSpikesFasterThanMinimumISI(x,misi);
end