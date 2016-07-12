function readAcousticSensorData(readFolderPath,saveFolderPath,delay)
%  readAcousticSensorData(readFolderPath,saveFolderPath)
%  readAcousticSensorData(readFolderPath,saveFolderPath,delay)
%  readAcousticSensorData(readFolderPath)
%
% Brian Goodwin, 2015-03-04
%
% 2016-07-12 -- v2
%
% File is saved under the name "acousticEmissionSensorData.mat"
%
% Make sure that the end of each path contains a '\' or '/' (depending on
% your system).
%
% This function also creates a "README_AEdata.txt" file indicating where
% the acoustic sensor data came from.
%
% "delay" variable is the set amount that aet needs to be added to "aet".
% The "delay" variable should have units of [ms] (milliseconds).

fid = dir(fullfile(readFolderPath,'*CH*.isf'));

fid = {fid.name};

nchan = length(fid);
ae = cell(1,nchan);

for k = 1:nchan
    [out,~] = isfread3(fullfile(readFolderPath,fid{k}));
    ae{k} = out.y;
    
end
if nargin<3
    aet = out.x;
else
    aet = out.x+delay/1e3;
end

if nargout<2 || isempty(saveFolderPath)
    save(fullfile(readFolderPath,'acousticEmissionSensorData.mat'),'ae','aet')
    fid = fopen(fullfile(readFolderPath,'README_AEdata.txt'),'w');
else
    save(fullfile(saveFolderPath,'acousticEmissionSensorData.mat'),'ae','aet')
    fid = fopen(fullfile(saveFolderPath,'README_AEdata.txt'),'w');
end


fprintf(fid,'The file named "acousticEmissionSensorData.mat" \ncame from data that is located in the folder:\n\n%s\n\nData is in raw form (unfiltered).\n\nVariables are "ae" and "aet" for the acoustic\nemission and time, respectively.',readFolderPath);
fclose(fid);