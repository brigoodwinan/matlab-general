function spline = hermite(p,v,N)
% spline  =  hermite(p,v,N)
%
% Brian Goodwin
%
% 2011-08-10 - v1
% 2013-10-18 - v2
%
% This program creates a spline when given points and vectors. Note that
% the magnitude of the vector plays a part in generating the 3-D spline.
% 
% INPUTS:
% p == points in 3D space in the order of connections
% v == vectors at each point supplying the trajectory of the spline
% N == number of points per spline
%
% OUTPUT:
% spline == 3D spline.

% Hermite spline simulation
A = [2,-2,1,1;-3,3,-2,-1;0,0,1,0;1,0,0,0];
np = size(p,1);
spline = zeros(N*(np-1),3);
n = N+1;
for k = 1:np-1
    pp = [p(k:k+1,:);v(k:k+1,:)];
    s = linspace(0,1,n);
    t = cat(2,s'.^3,s'.^2,s',ones(n,1));
    P = t*A*pp; % Hermite spline
    spline((k-1)*N+1:k*N,:) = P(1:N,:);
end
return

% Think about implimenting a resample function so the user can
% specify the number of points in the whole spline and so that
% the points are evenly spaced.