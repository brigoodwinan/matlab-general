function center = calculate_element_center(v,f)
% calculate_element_center.m
%
% Brian Goodwin
%
% 2013-07-03
%
% Calculates the centroid of triangle face elements.
%
% usage:
%
% center = calculate_element_center(v,f)
%
% v == nodes (nx3)
% f == faces (mx3)

[n,m] = size(f);
center = zeros(n,m);
center(:,1) = mean([v(f(:,1),1),v(f(:,2),1),v(f(:,3),1)],2);
center(:,2) = mean([v(f(:,1),2),v(f(:,2),2),v(f(:,3),2)],2);
center(:,3) = mean([v(f(:,1),3),v(f(:,2),3),v(f(:,3),3)],2);