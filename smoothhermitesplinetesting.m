
% ratio = (1.5)/2; % This ratio works for 90º angles.
% 
% for L = 1:8
%     offset = -L*ratio;
%     p1 = [L 0 0];
%     p2 = [0 offset 0];
%     v1 = [-1 0 0];
%     v2 = [0 -1 0];
%     
%     spline = hermite([p1;p2],[v1;v2].*2*L,20);
%     
%     plot(spline(:,1),spline(:,2),'.-')
%     hold on
% end
% axis equal
% hold off

ratio = (1.5)/2; % This ratio works well all around.

L = 2;

for theta = (15:5:45).*pi./180
    offset = L*ratio;
    p1 = [L 0 0];
    p2 = [offset*cos(theta) -offset*sin(theta) 0];
    v1 = [-1 0 0];
    v2 = [cos(theta) -sin(theta) 0];
    
    spline = hermite([p1;p2],[v1;v2].*2*L,20);
    
    plot(spline(:,1),spline(:,2),'.-')
    hold on
end
axis equal
hold off