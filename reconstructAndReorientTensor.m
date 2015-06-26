% generate_tensor_and_reorient.m
%
% NOT a function. Designed to be ran alone:
%
% >> generate_tensor_and_reorient
%
% 2011-10-12 Brian Goodwin
%
% 2013-07-20 - v1
% 2013-07-21 - v2
% 2013-07-24 - v3
% 2014-01-09 - v4
% 2014-01-09 - v5 (working version)
%
% Gets tensor values generated from dataset and creates MAT files for
% SCIRun tensor visualization and fiber tractography.
%
% All of these volumes will be set to be applied to a LATVOL in SCIRun.
%
% v3
% preparing gui for Hannah to run easily...
%
% v4
% Speeds up tensor flipping and avoids using a parfor loop.
%
% v5
% Solves the problem of registration issues. The SCS trasformations from
% BrainStorm takes care of the issue. The tensors still need flipping,
% which is performed in this code.
%    It should also be noted that the DTI transformation matrix, "m_dti"
% should only be applied be applied for scaling (if any) the coordinate
% frame. Instead, the sMRI.SCS.R and sMRI.SCS.T transformations should be
% applied to the MRI space directly. i.e.:
%
% xfm = [sMRI.SCS.R,sMRI.SCS.T; 0 0 0  1]
%
% These files are saved for applying to the head FEM for implimenting
% anisotropic properties. Current updates are being made for implimentation
% in SCIRun for tractography.

%% Loading appropriate files
initials = input('Enter patient/subject initials (e.g. BDG or BG): ','s');

files = cell(2,1);
test = zeros(2,1);

files{1} = input('DTI Data in *_tensor.nii.gz form (press enter to open GUI): ','s');

if isempty(files{1})
    [filename,pathname,filterindex] = uigetfile({'*.nii.gz', 'zipped NIFTI (*.nii.gz)';'*.nii','NIFTI-files (*.nii)'},...
        'Select *_tensor.nii.gz, and *_FA.nii.gz outputs from DTIFIT (FSL)','MultiSelect', 'on');
    if length(filename)~=2
        error('Invalid number of files selected. Make sure the NIFTI files *_tensor and *_FA are selected.');
    end
    if iscell(pathname)
        files{1} = [pathname{1},filename{1}];
        files{2} = [pathname{2},filename{2}];
    else
        files{1} = [pathname,filename{1}];
        files{2} = [pathname,filename{2}];
    end
    
else
    files{2} = input('FA Data in *_FA.nii.gz form (press enter to open GUI): ','s');
end

temp = files;

for i = 1:2
    if ~isempty(strfind(temp{i},'_tensor'))
        files{1} = temp{i};
        test(1) = 1;
    elseif ~isempty(strfind(temp{i},'_FA'))
        files{2} = temp{i};
        test(2) = 1;
    end
end

if sum(test)~=2
    error('One or more of the file names do not conform to the DTIFIT (FSL) output format (*_tensor.nii.gz and *_FA.nii.gz).');
end

if files{1}(end) == ' '
    files{1} = files{1}(1:end-1);
end
if files{2}(end) == ' '
    files{2} = files{2}(1:end-1);
end

%%% Transform applied to tensors:
transformfile = input('*.mat file with transform from sMRI to pial surface (SCS) (press enter to open GUI): ','s');
if isempty(transformfile)
    [xfmfilename,xfmpathname,filterindex] = uigetfile({'*.mat', 'MATLAB file (*.mat)'},...
        'Select *.mat file with 4x4 Transform','MultiSelect', 'off');
    transformfile = cat(2,xfmpathname,xfmfilename);
end
if transformfile(end) == ' '
    transformfile = transformfile(1:end-1);
end
load(transformfile) % xfm

pathname = pwd;

pathname = [pathname,filesep];
fprintf('\n\n\nOutput files will be saved to the following directory:\n')
disp(pathname)
disp(' ')
disp('The following transform will be applied to tensors in "*DTI_headFEM*":')
disp(transformfile)
disp(xfm(1:3,1:3))

%% DTI Analysis
% Get coordinates dimenions
nii = load_nii(files{1});
dim = nii.hdr.dime.dim(2:5); % nii.img(x,y,z,data)

% This transformation is for the coordinate frame ONLY.
m_dti = [nii.hdr.hist.srow_x;nii.hdr.hist.srow_y;nii.hdr.hist.srow_z;[0 0 0 1]]; % s == "scaling"
m_dti(1:3,4) = 0;

N = dim(1)*dim(2)*dim(3);

% Flipping the data for SCIRun (r == "raw")
rdti = nii.img;
rdti = reshape(rdti,N,dim(4));
rdti = double(rdti(:,[1,2,3,2,4,5,3,5,6]));

mfl = makehgtform('xrotate',pi);

dti_tract = xfm3d(rdti,mfl);

% For anisotropic head FEM
dti_headFEM = xfm3d(dti_tract,xfm);

%% FA
nii = load_nii(files{2});
dim = nii.hdr.dime.dim(2:5);
%fa = flipdim(nii.img,1);
fa = nii.img;
fa = reshape(fa,N,1);

%% Dimensions for LatVol
dim_dti = dim(1:3);
xyz = [0 0 0;dim_dti];
xyz(:,4) = 1;
xyz = xyz*m_dti';

%% Display the spacing
disp('---------------------------------------')
disp('Spacing for TendFiber SCIRun subnetwork:')
fprintf('\nx-spacing: %0.5f\nx-minimum: %0.5f\n\ny-spacing: %0.5f\ny-minimum: %0.5f\n\nz-spacing: %0.5f\nz-minimum: %0.5f\n',m_dti(1,1),min(xyz(:,1)),m_dti(2,2),min(xyz(:,2)),m_dti(3,3),min(xyz(:,3)));
fprintf('---------------------------------------\n\n\n')
%% SCIRun: CreateTensorArray -----------------------------------------
dt = datestr(now,'yyyymmdd_HHMM');

dtianisotropydata = [pathname,initials,'_DTI_headFEM_',dt,'.mat'];
save(dtianisotropydata,'dti_headFEM','-v7');
fprintf('DTI data for anisotropy in head FEM saved as:\n  %s\n\n',dtianisotropydata);

dtitractographydata = [pathname,initials,'_DTI_tractography_',dt,'.mat'];
save(dtitractographydata,'dti_tract','-v7');
fprintf('DTI data for tractography saved as:\n  %s\n\n',dtitractographydata);

fadata = [pathname,initials,'_FA_',dt,'.mat'];
save(fadata,'fa','-v7');
fprintf('FA data saved as:\n  %s\n\n',fadata);

lvtform = [pathname,initials,'_LatVol_XFM_',dt,'.mat'];
save(lvtform,'m_dti','-v7');
fprintf('LatVol transform matrix saved as:\n  %s\n\n',lvtform);

lvsize = [pathname,initials,'_LatVol_Size_',dt,'.mat'];
save(lvsize,'dim_dti','-v7');
fprintf('LatVol Size saved as:\n  %s\n\n',lvsize);