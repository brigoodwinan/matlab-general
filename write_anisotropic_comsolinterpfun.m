% THIS FILE HAS BEEN DEPRECATED BY THE CODE IN JLmakeheadtetmesh.m
%
% write_anisotropic_comsolinterpfun.m
%
% 2014-01-10, Brian Goodwin
%
% Reads in the anisotropic mesh generated from SCIRun in the MR head model
% folder and writes it to a mesh interpolation file for COMSOL.
%
% Based on the histogram of eigenvalues, the tensors were scaled so that
% largest 10% of eigenvalues have a value of 1.65 S/m. This scaling is done
% to provide a realistic conductivity.

scaling = .7e3; % The tensors are scaled by this to provide realistic conductivity

filename = '~/Documents/Project_HEAD_MODEL/HeadModel_MR/m2/MR_anisotropic_comsolgridinterp.txt';

% I have elected to abondon the SCIRun way of doing this due to memory
% issues. My current approach is to load in the generated DTI data and
% transformation matrices to build a latvol (ndgrid) in matlab. The result
% will be a clipped latvol and a grid file for COMSOL.

load ~/Documents/Project_HEAD_MODEL/HeadModel_MR/m2/MR_xfm_sMRItoSCS.mat % xfm
load ~/Documents/Project_HEAD_MODEL/HeadModel_MR/m2/MR_LatVol_XFM_20140114_1503.mat % m_dti
load ~/Documents/Project_HEAD_MODEL/HeadModel_MR/m2/MR_LatVol_Size_20140114_1503.mat % dim_dti
load ~/Documents/Project_HEAD_MODEL/HeadModel_MR/m2/MR_DTI_headFEM_20140114_1503.mat % dti_headFEM (Nx9) (no transforming needed)

dti = reshape(dti_headFEM,dim_dti(1),dim_dti(2),dim_dti(3),9);

dti = dti.*scaling;

xfm = xfm*m_dti;

[dti,latvol_xfm] = trimlatvol3d(dti,xfm);

sz = size(dti); latvol_dim = sz(1:3);

dti = reshape(dti,prod(sz(1:3)),9);

% save ./HeadModel_MR/m2/trimmed_DTI.mat latvol_dim latvol_xfm dti -v7

prodsz = prod(sz(1:3));
[x,y,z] = ndgrid(0:sz(1)-1,0:sz(2)-1,0:sz(3)-1);
xyz = [reshape(x,1,prodsz);reshape(y,1,prodsz);reshape(z,1,prodsz)];
clearvars x y z
xyz(4,:) = 1;

xyz = latvol_xfm*xyz;
xyz = xyz(1:3,:)';

%%% Creating an interpolant to setup a grid interpolation for COMSOL, which
%%% would contain data that only includes the upper triangle. DLMWRITE is
%%% then used to make the grid file due to ease.

dti = dti(:,[1,2,3,5,6,9]); % Just using upper/lower triangle

gridmin = min(xyz(logical(dti(:,1)),:));
gridmax = max(xyz(logical(dti(:,1)),:));

% ds = diag(m_dti);
% ds = ds(1:3); % [mm]
ds = 1; % [mm], ds can be set manually. For a smaller filesize, use <1mm.
qgrid = {gridmin(1):ds(1):gridmax(1),gridmin(2):ds(2):gridmax(2),gridmin(3):ds(3):gridmax(3)};

xfm_qgrid = [eye(4,3),[gridmin';1]];
dim_qgrid = [length(qgrid{1}),length(qgrid{2}),length(qgrid{3})];

DTI = cell(6,1);

x = xyz(:,1); y = xyz(:,2); z = xyz(:,3);

disp('Interpolating...')
parfor k = 1:6
    Fq = scatteredInterpolant(x,y,z,dti(:,k));
    DTI{k} = Fq(qgrid);
end

%%% NOTE that the remaining zeros in the DTI data need to be
%%% replaced

sz = size(DTI{1});
len = prod(sz(2:3));
dti = cell(6,1);
for k = 1:6
    dti{k}(:,:) = reshape(DTI{k},sz(1),len).';
end

setloc = ~logical(dti{1});
dti{1}(setloc) = scaling/1e3;
dti{4}(setloc) = scaling/1e3;
dti{6}(setloc) = scaling/1e3;

dlmwrite(filename,'%Grid','delimiter','')
dlmwrite(filename,qgrid{1},'-append','precision','%9.4f','delimiter',' ')
dlmwrite(filename,qgrid{2},'-append','precision','%9.4f','delimiter',' ')
dlmwrite(filename,qgrid{3},'-append','precision','%9.4f','delimiter',' ')
for k = 1:6
    if k==1
        fun = 'a11';
    elseif k==2
        fun = 'a21';
    elseif k==3
        fun = 'a31';
    elseif k==4
        fun = 'a22';
    elseif k==5
        fun = 'a32';
    elseif k==6
        fun = 'a33';
    end
    dlmwrite(filename,['%Data (',fun,')'],'-append','roffset',1,'delimiter','')
    dlmwrite(filename,dti{k},'-append','delimiter',' ','precision','%8.4f')
end

dti_qgrid = [reshape(DTI{1},[],1),reshape(DTI{2},[],1),reshape(DTI{3},[],1),reshape(DTI{4},[],1),reshape(DTI{5},[],1),reshape(DTI{6},[],1)];
dti_qgrid = dti_qgrid(:,[1,2,3,2,4,5,3,5,6]);
uisave({'DTI','qgrid'},'anisotropic_comsolgridinterp.mat')