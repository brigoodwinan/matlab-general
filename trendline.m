function [P,rsq] = trendline(x,y,order)
% [P,rsq] = trendline(x,y,order)
% [P,rsq] = trendline(x,y)
%
% Brian Goodwin 2014-09-18
%
% Outputs polynomial coefficients and adjusted coefficient of
% determination given x and y data. The default order is 1.
%
% P values could normally be obtained via P = polyfit(x,y,1);
%
% Trendline can be plotted via:
% yfit = polyval(P,[xmin,xmax]);
% plot([xmin,xmax],yfit,'k');
% 

if nargin<3
    order = 1;
end

P = polyfit(x,y,order);
yfit = polyval(P,x);
yresid = y-yfit;
SSresid = sum(yresid.^2);
SStotal = (length(y)-1)*var(y);

if order>1
    rsq = 1-SSresid/SStotal*(length(x)-1)/(length(x)-order-1);
else
    rsq = 1-SSresid/SStotal;
end