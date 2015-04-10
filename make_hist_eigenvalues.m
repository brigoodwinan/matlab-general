% make_hist_eigenvalues.m
%
% 2014-01-10, Brian Goodwin
%
% Constructs a histogram of non-zero eigenvalues from output *.nii.gz files
% from DTIFIT (FSL).
%
% A GUI prompts the user to load in a *_L1.nii.gz file from an FSL folder.

[filename,pathname,filterindex] = uigetfile({'*.nii.gz', 'zipped NIFTI (*.nii.gz)';'*.nii','NIFTI-files (*.nii)'},...
    'Select *_L1.nii.gz','MultiSelect', 'off');

nii = load_nii([pathname,filename]);
s = reshape(nii.img,[],1);
s = s(logical(s));
s = double(s);
hist(s,200);