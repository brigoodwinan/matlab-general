function out = dostMatrixOneSide(in)
% out = dostMatrixOneSide(in)
%
% Brian Goodwin 2015-04-22
%
% Outputs only the single sided DOST.

n = length(in);

if pow2(nextpow2(n))~=n
    error('Signal must have a length of pow2(nextpow2(n)).')
end

l = fix(n/2);

out = dostMatrix(in);

out = out(l:n,:);