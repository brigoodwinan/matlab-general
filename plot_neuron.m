function plot_neuron(node,edge,data,opt)
% plot_neuron(node,edge)
% plot_neuron(node,edge,data)
% plot_neuron(node,edge,data,opt)
% plot_neuron(node,edge,[],opt)
%
% Brian Goodwin, 2014-09-30
%
% Plots edge field of neuron given the node and edge. Very simple.
%
% INPUTS:
% node: n-by-3 or n-by-2 points
% edge: m-by-2 edge connections
% data: n-by-1 scalar nodal data to be colored - assumed to be
%    intracellular potential (between -90 and 30 mV)
% opt: (optional) the columns to plot if a 2D plot is desired (1-by-2).


if nargin>3
    if isempty(data)
        figure
        plot([node(edge(:,1),opt(1)),node(edge(:,2),opt(1))].',[node(edge(:,1),opt(2)),node(edge(:,2),opt(2))].','k')
        axis equal
    else
        data = (data+90)/(30--90);
        data(data>1) = 1;
        data(data<0) = 0;
        data = map_data2element(edge,data);
        
        figure
        for k = 1:size(edge,1)
            plot([node(edge(k,1),opt(1)),node(edge(k,2),opt(1))].',[node(edge(k,1),opt(2)),node(edge(k,2),opt(2))].','color',get_color_for_colorbar(data(k)))
            hold on
        end
        hold off
        axis equal
    end
else
    if nargin>2
        data = (data+90)/(30--90);
        data(data>1) = 1;
        data(data<0) = 0;
        data = map_data2element(edge,data);
        
        figure
        for k = 1:size(edge,1)
            plot3([node(edge(k,1),1),node(edge(k,2),1)].',[node(edge(k,1),2),node(edge(k,2),2)].',[node(edge(k,1),3),node(edge(k,2),3)].','color',get_color_for_colorbar(data(k)))
            hold on
        end
        hold off
        axis equal
    else
        figure
        plot3([node(edge(:,1),1),node(edge(:,2),1)].',[node(edge(:,1),2),node(edge(:,2),2)].',[node(edge(:,1),3),node(edge(:,2),3)].','k')
        axis equal
    end
end