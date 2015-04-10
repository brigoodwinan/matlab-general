function c = get_color_for_colorbar(value)
% c = get_color_for_colorbar(value)
%
% "value" is between 0 and 1 where 0 is "cold" or (i.e. blue) and 1 is 
% "hot" (i.e. red). This is a rainbow colormap. this RGB color can then be
% used in the plot command for example:
%
% "value" can also be a column vector (n-by-1). The output, c will then be
% n-by-3
%
% plot(x,y,'.','color',get_color_for_colorbar(value))

value = ceil(value*256);
value(value<1) = 1;

% define colorbar with 256 colors:
block = 1:64;
ds = 1/64;
cb = zeros(256,3);
cb(block,3) = 1;
cb(block,2) = (ds:ds:1)';
cb(block+64,3) = (1-ds:-ds:0)';
cb(block+64,2) = 1;
cb(block+64*2,1) = (ds:ds:1)';
cb(block+64*2,2) = 1;
cb(block+64*3,2) = (1-ds:-ds:0)';
cb(block+64*3,1) = 1;

% % Debugging with plot
% figure(1)
% hold on
% for k=1:256
%     plot(k,0,'.','markersize',30,'color',cb(k,:))
% end
% hold off

c = cb(value,:);