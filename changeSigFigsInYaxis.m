function changeSigFigsInYaxis(h)
% changeSigFigsInYaxis(h)
%
% Brian Goodwin 2015-08-28
%
% Changes the y tick labels to a format like this: 1234.123 ('%0.3f').
%
% INPUT:
% h: the axis handle of the figure that you desire to change. 
%       i.e. >> h = gca;

for k = 1:length(h.YTick)
    h.YTickLabel{k} = num2str(h.YTick(k),'%0.3f');
end