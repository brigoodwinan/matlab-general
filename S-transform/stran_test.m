% stran_test.m

% Sample signal "h"
h = randn(1001,1);
h(401:600) = 20.*sin((1:200).'*2*pi/10);

N = pow2(nextpow2(size(h,1)));
Nhalf = N/2;

f = ifftshift(-Nhalf:Nhalf-1)./N;
% hft = circshift(dft(h,N),Nhalf);
hft = fft(h,N);

% Preallocation...
% S = zeros(N ... % figure out if this is to be N/2... the hft may need to
% be truncated to N/2 in the loop...

S = cell(Nhalf+1,1);
store = cell(Nhalf+1,1);
for n = 2:Nhalf+1
    w = exp(-2*pow2(pi.*f./f(n-1)));
    store{n} = w;
    tmp = circshift(hft,n-1).';
    tmp = tmp.*w;
    S{n} = ifft(tmp);
end
S{1} = ones(1,N)*mean(ifft(hft));
S = cell2mat(S);
store = cell2mat(store);

figure
ax(1) = subplot(2,1,1);
plot(h,'k')
ax(2) = subplot(2,1,2);
imagesc(1:N,linspace(0,0.5,size(S,1)),abs(S),[0,0.5]);
axis xy
linkaxes(ax,'x')

% test with stran
[st,sw] = stran(h);

figure
ax(1) = subplot(2,1,1);
plot(h,'k')
ax(2) = subplot(2,1,2);
imagesc(1:N,linspace(0,0.5,size(st,1)),abs(st),[0,.5]);
axis xy
linkaxes(ax,'x')