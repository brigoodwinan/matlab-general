function out = dostMatrix(in)
% out = dostMatrix(in);
% 
% Brian Goodwin, 2015-04-22
%
% Outputs the DOST matrix using the dost() and rearrange_dost() functions.
%
% in: n-by-1 time series
% out: n-by-n rearranged DOST coefficients for time-frequency plotting.

n = length(in);

if pow2(nextpow2(n))~=n
    error('Signal must have a length of pow2(nextpow2(n)).')
end

out = rearrange_dost(abs(dost(in)).');