function out = interp_dti_data(dti_headFEM,xfm,m_dti,dim_dti,interpcoords)
% out = interp_dti_data(data,xfm,m_dti,dim_dti,interpcoords)
%
% Brian Goodwin 2014-09-22
%
% Interpolates DTI data that has been customized for my modeling pipeline.
%
% INPUTS:
% data: DTI data n-by-m-by-p-by-9 (4D) grid
%       containing DTI tensors having latvol properties. DTI tensors are
%       scaled by 0.7*1e3 (Tuch et al.). To change this, edit this file and
%       change the "scaling" variable.
% xfm: 4-by-4 transformation matrix to place the tensors in coordinate
%       space. NOTE: this transformation is not meant to do anything to
%       tensor orientation. Tensors should be loaded in with appropriate
%       transforms already applied.
% m_dti: 4-by-4 transform as outputted from FSL. This is likely just
%       eye(4).
% dim_dti: array of the latvol dimensions for the dti data
% interpcoords: Coordinates to retrieve DTI tensors from. (N-by-3)
%
% OUTPUT:
% out: N-by-6 tensors of the upper triangle.

scaling = 0.7*1e3; % changed 2014-07-17 (Tuch et al.)

xfm = xfm*m_dti;
invxfm = inv(xfm);

dti_headFEM = dti_headFEM.*scaling;

dti11 = reshape(dti_headFEM(:,1),dim_dti(1),dim_dti(2),dim_dti(3));
dti12 = reshape(dti_headFEM(:,2),dim_dti(1),dim_dti(2),dim_dti(3));
dti13 = reshape(dti_headFEM(:,3),dim_dti(1),dim_dti(2),dim_dti(3));
dti22 = reshape(dti_headFEM(:,5),dim_dti(1),dim_dti(2),dim_dti(3));
dti23 = reshape(dti_headFEM(:,6),dim_dti(1),dim_dti(2),dim_dti(3));
dti33 = reshape(dti_headFEM(:,9),dim_dti(1),dim_dti(2),dim_dti(3));

[x1,x2,x3] = ndgrid(0:dim_dti(1)-1,0:dim_dti(2)-1,0:dim_dti(3)-1);

interpcoords = xfm3d(interpcoords,invxfm,1);
mx = max(interpcoords);
mn = min(interpcoords);

big = 5;

% Logical indexing
logind = (x1<(mx(1)+big))&(x1>(mn(1)-big))&(x2<(mx(2)+big))&(x2>(mn(2)-big))&(x3<(mx(3)+big))&(x3>(mn(3)-big));

dimx1 = max(max(sum(logind,1)));
dimx2 = max(max(sum(logind,2)));
dimx3 = max(max(sum(logind,3)));
x1 = x1(logind);
x2 = x2(logind);
x3 = x3(logind);
dti11 = dti11(logind);
dti12 = dti12(logind);
dti13 = dti13(logind);
dti22 = dti22(logind);
dti23 = dti23(logind);
dti33 = dti33(logind);

x1 = reshape(x1,dimx1,dimx2,dimx3);
x2 = reshape(x2,dimx1,dimx2,dimx3);
x3 = reshape(x3,dimx1,dimx2,dimx3);
dti11 = reshape(dti11,dimx1,dimx2,dimx3);
dti12 = reshape(dti12,dimx1,dimx2,dimx3);
dti13 = reshape(dti13,dimx1,dimx2,dimx3);
dti22 = reshape(dti22,dimx1,dimx2,dimx3);
dti23 = reshape(dti23,dimx1,dimx2,dimx3);
dti33 = reshape(dti33,dimx1,dimx2,dimx3);

t11 = griddedInterpolant(x1,x2,x3,dti11,'linear');
t12 = griddedInterpolant(x1,x2,x3,dti12,'linear');
t13 = griddedInterpolant(x1,x2,x3,dti13,'linear');
t22 = griddedInterpolant(x1,x2,x3,dti22,'linear');
t23 = griddedInterpolant(x1,x2,x3,dti23,'linear');
t33 = griddedInterpolant(x1,x2,x3,dti33,'linear');

out = cat(2,t11(interpcoords),t12(interpcoords),t13(interpcoords),t22(interpcoords),t23(interpcoords),t33(interpcoords));