function readNavyAcousticCSVFile(filename)
%
% readNavyAcousticCSVFile(filename)
% readNavyAcousticCSVFile(filename)
% readNavyAcousticCSVFile(filename,savematfile)
%
% Brian Goodwin, 2015-07-02
%
% Reads in Navy Acoustic files that typically are named something like...
% 'dodc2901.csv'.
%
% INPUTS:
% filename: full path (string) of filename (just drag and drop the filename
%     into the workspace.
% savematfile: name of *mat file to be saved. Automatically saved to the
%     folder it came from.
%
% OUTPUTS:
% dat: data output. The first column is "time"
% headings:

% %
% % For Debugging...
% filename = '/Users/cbutson/Documents/Brian/project_acousticSensorAnalysis/data/PMHS/navy-lumbar/DODC2900/AcousticSensor/dodc2901.csv';
% %
% %

fid = fopen(filename,'r');

ae{1} = [];
i = 0;
while isempty(ae{1})
    i = i+1;
    str = fgetl(fid);
    if ~isempty(str)
        ae = textscan(str,'%f','Delimiter',',');
    end
end
frewind(fid);
% for k = 1:i-1
%     tline = fgetl(fid);
% end

ae = textscan(fid,'%f','Delimiter',',','HeaderLines',i-1);
ae = ae{1}(~isnan(ae{1}));
ae = reshape(ae,3,numel(ae)/3); % will get an error here if wrong format.
aet = ae(:,1);
ae = {ae(:,2)};
fclose(fid);

[pathstr,fname]= fileparts(filename);
save(fullfile(pathstr,['acousticData_',fname,'.mat']),'ae','aet')
fid = fopen(fullfile(pathstr,'README_AEdata.txt'),'w');
fprintf(fid,'The file named "acousticEmissionSensorData.mat" \ncame from data that is located in the folder:\n\n%s\n\nData is in raw form (unfiltered).\n\nVariables are "ae" and "aet" for the acoustic\nemission and time, respectively.',pathstr);
fclose(fid);