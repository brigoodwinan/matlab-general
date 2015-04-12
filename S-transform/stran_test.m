% stran_test.m
%
% Brian Goodwin
%
% Testing S-transform work
%
% v2 Notes
% testing script only uses stockwell function instead of custom code.

load mtlb % mtlb
h = repmat(mtlb,5,1);
N = size(h,1);

if ~isPoolOpen
    gcp
end

S = stockwell(h);

h1 = figure;
ax(1) = subplot(2,1,1);
plot(h,'k')
ax(2) = subplot(2,1,2);
imagesc(1:N,linspace(0,0.5,size(S,1)),abs(S));
colormap(ax(1),'default')
axis xy
linkaxes(ax,'x')