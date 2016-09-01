load ../data/mech012.mat

in = mech.x(:,2:end);

maSize = 1000;

[b,a] = butter(2,.1,'high');
v = filtfilt(b,a,in);
vstd = std(v);
logind = bsxfun(@lt,abs(v),vstd);

ma = filter(ones(maSize,1)./maSize,1,in);
sigma = filter(ones(maSize,1)./maSize,1,(in-ma));

stdev = std(in);
logind = bsxfun(@lt,sigma,stdev) & logind;
logind(1:maSize-1,:) = false;

m = size(in,2);
out = zeros(1,m);
figure
for k = 1:m
    out(k) = mean(in(logind(:,k),k));
    
    plot(mech.x(logind(:,k),1),in(logind(:,k),k),'.')
    hold on
end
hold off