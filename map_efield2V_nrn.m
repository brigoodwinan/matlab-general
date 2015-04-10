function V = map_efield2V_nrn(nrn,edge,ex,ey,ez)
% V = map_efield2V_nrn(nrn,edge,ex,ey,ez)
%
% Given the electric field at each node in "nrn", the voltage is calculated
% indirectly by int(dot(E,ds),x). 
%
% This function is setup for the pyramidal cell (Mod. Amatrudo et al.) with
% a 20mm axon. If you wish to change this, create a new multiplication
% matrix (see Project_CORTICAL_MODEL/JL_make_cortical_model.m) and change
% line 20.
%
% INPUTS:
% nrn: neuron nodes in [mm] (n-by-3)
% edge: neuron edge connections (m-by-2)
% ex, ey, ez: electric field on neuron (1-by-n) in [V/m]
%
% OUTPUT:
% V: voltage on the neuron.

load efield_mult_matrix_ax20mm.mat % s

% ds vector in the direction of parent--->child
dx = (nrn(edge(:,1),1)-nrn(edge(:,2),1))./1e3; % [mm] --> [m]
dy = (nrn(edge(:,1),2)-nrn(edge(:,2),2))./1e3; % [mm] --> [m]
dz = (nrn(edge(:,1),3)-nrn(edge(:,2),3))./1e3; % [mm] --> [m]

ex = ex(edge(:,2)); 
ey = ey(edge(:,2)); 
ez = ez(edge(:,2));

tmp = bsxfun(@times,s,ex)*dx+bsxfun(@times,s,ey)*dy+bsxfun(@times,s,ez)*dz;
V = tmp-mean(tmp);