function out = stockwell(h)
% out = stockwell(h)
%
% Brian Goodwin 2015-04-11
%
% 2015-04-11 - v2
%
% Stockwell transform on 1D time series data. Signal input can be of any
% length (even or odd).
%
% Computes the stockwell transform using a "for loop" for the purpose of
% conserving RAM (this is an alternative to "stran.m").l
%
% INPUT:
% in: n-by-1 vector array of time series data
%
% OUTPUT:
% out: n/2-by-n matrix of the stockwell transform (note
%     that it is single sided).

N = size(h,1);
Nhalf = fix(N/2);

if logical(rem(N,2))
    const = 1;
else
    const = 0;
end

f = ifftshift(-Nhalf:Nhalf-1+const)./N;
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

%% Stockwell computation for parfor loop
function out = stockwell_subfun(f,n,hft)
w = exp(-2*(pi.*f./f(n)).^2);
tmp = circshift(hft,n-1).';
tmp = tmp.*w;
out = ifft(tmp);
end