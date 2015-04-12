function out = stockwell(h)
% out = stockwell(h)
%
% Brian Goodwin 2015-04-11
%
% Stockwell transform on 1D time series data.
%
% Uses for loops for the purpose of conserving RAM.
%
% INPUT:
% in: n-by-1 vector array of time series data
%
% OUTPUT:
% out: pow2(nextpow2(h))/2-by-n matrix of the stockwell transform (note
%     that it is single sided).

N = pow2(nextpow2(size(h,1)));
Nhalf = N/2;

f = ifftshift(-Nhalf:Nhalf-1)./N;
hft = fft(h,N);

out = cell(Nhalf+1,1);
if isPoolOpen
    parfor n = 2:Nhalf+1
        out{n} = stockwell_subfun(f,n,hft);
    end
else
    for n = 2:Nhalf+1
        out{n} = stockwell_subfun(f,n,hft);
    end
end
out{1} = ones(1,N)*mean(ifft(hft));
out = cell2mat(out);
return
end

function out = stockwell_subfun(f,n,hft)
w = exp(-2*(pi.*f./f(n)).^2);
tmp = circshift(hft,n-1).';
tmp = tmp.*w;
out = ifft(tmp);
end