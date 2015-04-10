% stran_test.m

h = randn(1000,1);
h(401:600) = .3*randn(200,1)+10.*sin((1:200).'*pi/10);
N = pow2(nextpow2(size(h,1)));

f = ifftshift(-N/2:N/2-1)./N;
% f = (0:N-1).'./N;

hft = fft(h,N);

% Preallocation...
% S = zeros(N ... % figure out if this is to be N/2... the hft may need to
% be truncated to N/2 in the loop...

S = cell(1,N);
for m = 1:N
    w = exp(-pi*(0:N-1).^2./m^2).';
    tmp = circshift(hft,m-1);
    B = tmp.*w;
    S{m} = ifft(B);
end

S = cell2mat(S).';

figure
ax(1) = subplot(2,1,1);
plot(h,'k')
ax(2) = subplot(2,1,2);
imagesc(1:N,linspace(0,2*pi,size(S,1)),abs(S),[0,0.25]);
axis xy
linkaxes(ax,'x')