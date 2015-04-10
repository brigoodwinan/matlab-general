% function V = Efield2V_nrnedge(neuron,E)
% V = Efield2V_nrnedge(neuron,E)
%
% Given an edge field ("neuron" structure with node and edge field),
% computes the Voltage at each node, when only E is given.
% neuron:
%   *.node: n x 3 points in 3D space.
%   *.edge: m x 2 edge connections
%
% E and neuron.node must be the same length.
%
% V: output voltage

% % FOR DEBUGGING:
% load /Users/1773goodwib/Documents/Project_NEURON_MODEL/neuron_10mm_edgefield.mat
% load /Users/1773goodwib/Documents/Project_NEURON_MODEL/neuron_probe_test.mat % scirunfield
% v = 1./sqrt(sum((repmat(scirunfield.node',length(neuron.node),1) - neuron.node).^2,2));
% v = v./max(v);
% E = zeros(length(neuron.node),3);
% E(:,3) = v;

neuron.node = rand(10,3)*.1-.05;
neuron.node(:,3) = linspace(0,1,10).^2;
neuron.edge = [(1:9)',(2:10)'];
E = zeros(10,3);
E(:,3) = 1;

% % % ORIGINAL CODE STARTS HERE % % %

n = size(E,1);
ds = -1./abs(neuron.node(neuron.edge(:,1),:) - neuron.node(neuron.edge(:,2),:));
dsx = ds(:,1); dsy = ds(:,2); dsz = ds(:,3);

% Find change in Efield

Kx = sparse(neuron.edge(:,1),neuron.edge(:,1),dsx,n,n);
Kx = Kx + sparse(neuron.edge(:,2),neuron.edge(:,2),dsx,n,n);
Kx = Kx + sparse(neuron.edge(:,1),neuron.edge(:,2),-dsx,n,n);
Kx = Kx + sparse(neuron.edge(:,2),neuron.edge(:,1),-dsx,n,n);

Ky = sparse(neuron.edge(:,1),neuron.edge(:,1),dsy,n,n);
Ky = Ky + sparse(neuron.edge(:,2),neuron.edge(:,2),dsy,n,n);
Ky = Ky + sparse(neuron.edge(:,1),neuron.edge(:,2),-dsy,n,n);
Ky = Ky + sparse(neuron.edge(:,2),neuron.edge(:,1),-dsy,n,n);

Kz = sparse(neuron.edge(:,1),neuron.edge(:,1),dsz,n,n);
Kz = Kz + sparse(neuron.edge(:,2),neuron.edge(:,2),dsz,n,n);
Kz = Kz + sparse(neuron.edge(:,1),neuron.edge(:,2),-dsz,n,n);
Kz = Kz + sparse(neuron.edge(:,2),neuron.edge(:,1),-dsz,n,n);

Vx = Kx(2:n,2:n)\E(2:n,1);
Vy = Ky(2:n,2:n)\E(2:n,2);
Vz = Kz(2:n,2:n)\E(2:n,3);

V = Vx+Vy+Vz;
V = cat(1,0,V);

diff(diff(V))

% % FOR DEBUGGING
% testplot.node = neuron.node;
% testplot.data = V;
% testplot.edge = neuron.edge;
% save neuron_test_code.mat testplot -v7
% save neuron_test_proof.mat neuronproof -v7
% neuronproof.data = E;
% save neuron_test_proof_Efield.mat neuronproof -v7
% 
% figure(1)
% hold on
% mnv = min(V);
% mxv = max(V);
% for k=1:n
%     plot3(neuron.node(k,1),neuron.node(k,2),neuron.node(k,3),'.','markersize',30,'color',get_color_for_colorbar((V(k)-mnv)./(mxv-mnv)));
% end
% hold off
% axis equal
