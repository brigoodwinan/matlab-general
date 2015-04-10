% check_tensor_via_hist.m
%
% Brian Goodwin
% 
% 2013-07-23
%
% Loads data from monkey and calculates the histogram
% and compares it to data from MR DWI study. The units
% should be the same. If they are the same, the orders
% of magnitudes should be the same, i.e. the histograms
% should look very similar.

nii1 = load_nii('/Volumes/Butson_Lab/Projects/Project_FiberTractographyPipeline/FibTracking_Scirun/WeiMonkeyDTIStudy/UWRMAC-DTI271_Paxinos.nii');
nii2 = load_nii('/Volumes/Butson_Lab/Users/BGoodwin/Project_HEAD_MODEL/DWI_Manoj/p805/e844/s7645/dti_combined_tensor.nii.gz');

% nii1 has the upper triangle in the 5th dim
% nii2 has the upper triangle in the 4th dim

dim1 = nii1.hdr.dime.dim;
dim1 = dim1(2:dim1(1));
n1 = dim1(1)*dim1(2)*dim1(3);
dim2 = nii2.hdr.dime.dim;
dim2 = dim2(2:dim2(1));
n2 = dim2(1)*dim2(2)*dim2(3);

monk = reshape(nii1.img,n1,6);
hum = reshape(nii2.img,n2,6);

monk = monk(logical(monk(:,1)),:);
n1 = length(monk);
hum = hum(logical(hum(:,1)),:);
n2 = length(hum);

monk = [monk(:,1:3),monk(:,2),monk(:,4:5),monk(:,[3,5]),monk(:,6)];
hum = [hum(:,1:3),hum(:,2),hum(:,4:5),hum(:,[3,5]),hum(:,6)];

monkval = cell(n1,1);
parfor i = 1:n1
	t = reshape(monk(i,:),3,3);
	e = abs(eig(t));
	monkval{i} = e(1);
end
monke = cell2mat(monkval);

humval = cell(n2,1);
parfor i = 1:n2
	t = reshape(hum(i,:),3,3);
	e = abs(eig(t));
	humval{i} = e(1);
end
hume = cell2mat(humval);

% Histograms
[Nm,Xm] = hist(monke);
[Nh,Xh] = hist(hume);