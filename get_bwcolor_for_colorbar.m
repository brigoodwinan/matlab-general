function c = get_bwcolor_for_colorbar(value)
% c = get_bwcolor_for_colorbar(value)
%
% Get grayscale color (1 of 256 colors) with input between 0 and 1.
%
% "value" is between 0 and 1 where 0 is "cold" (i.e. white) and 1 is 
% "hot" (i.e. black). This is a rainbow colormap. this RGB color can then be
% used in the plot command for example:
%
% "value" can also be a column vector (n-by-1). The output, c will then be
% n-by-3
%
% plot(x,y,'.','color',get_bwcolor_for_colorbar(value))

value = ceil(value*256);
value(value<1) = 1;

% define colorbar with 256 colors:
ds = 1/256;
cb = flipud(repmat((ds:ds:1).',1,3));

c = cb(value,:);

% % Use the following for debugging...
% % Debugging with plot
% figure(1)
% hold on
% for k = linspace(0,1,256)
%     plot(k,0,'.','markersize',30,'color',get_bwcolor_for_colorbar(k))
% end
% hold off