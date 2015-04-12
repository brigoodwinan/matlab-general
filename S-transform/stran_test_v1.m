% stran_test.m

load mtlb % mtlb
h = mtlb;

% % Sample signal "h"
% h = randn(1001,1);
% h(401:600) = 20.*sin((1:200).'*2*pi./linspace(3,20,200).');

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
    w = exp(-2*(pi.*f./f(n)).^2);
    store{n} = w;
    tmp = circshift(hft,n-1).';
    tmp = tmp.*w;
    S{n} = ifft(tmp);
end
S{1} = ones(1,N)*mean(ifft(hft));
S = cell2mat(S);
store = cell2mat(store);

h1 = figure;
ax(1) = subplot(2,1,1);
plot(h,'k')
ax(2) = subplot(2,1,2);
imagesc(1:N,linspace(0,0.5,size(S,1)),abs(S));
colormap(ax(1),'default')
axis xy
linkaxes(ax,'x')

% test with stran
[st,g] = stran(h);

h2 = figure;
ax(1) = subplot(2,1,1);
plot(h,'k')
ax(2) = subplot(2,1,2);
imagesc(1:N,linspace(0,0.5,size(st,1)),abs(st));
colormap(ax(2),'default')
axis xy
linkaxes(ax,'x')