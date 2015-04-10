function P = hermite_v1(p,N)
% P  =  hermite(p,N)
%
% Brian Goodwin
%
% 2011-08-10 - v1
% 2013-10-18 - v2
%
% This program creates a spline when given points and vectors. Note that
% the magnitude of the vector plays a part in generating the 3-D spline.
% 
% User inputs a matrix "p" which is a 4xD matrix where D is the number of
% dimensions (3, in this case).  
% 
% The matrix, "p", consists of point 1, point 2, slope 1, and slope 2:
%
% [ x_i  x_j  x_k  ]
% [ y_i  y_j  y_k  ]
% [ mx_i mx_j mx_k ]
% [ my_i my_j my_k ]
%
% Where "m" is a vector containing the projection of the spline at the
% corresponding point. "x" and "y" are the two point locations in free
% space.
%
% "N" is the number of points in the spline. 

% Hermite spline simulation
s = linspace(0,1,N);
t = [s'.^3 s'.^2 s' ones(N,1)];
A = [2,-2,1,1;-3,3,-2,-1;0,0,1,0;1,0,0,0];

P = t*A*p; % Hermite spline