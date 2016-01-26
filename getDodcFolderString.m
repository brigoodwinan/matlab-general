function out = getDodcFolderString(IDnum,strInput)
% out = getDodcFolderString(IDnum,strInput)
%
% Brian Goodwin 2015-12-16
%
% Retrieves the folder string for either acoustic or mechanical data for
% DODC data.
%
% INPUTS:
% IDnum: the data ID number of the DODC experiment.
% strInput: tells the function to get the acoustic or mechanical data
%     folder string:
%     'mech' - retrieves mechanical data folder string.
%     'acoustic' - retrieves acoustic data folder string.
%
% OUTPUTS:
% out: the folder string so that the acoustic data or mechanical data can
%     be loaded; e.g., load(getDodcFolderString(3301,'mech'))
%
% EXAMPLES OF FOLDER STRINGS:
% load(fullfile(fdata.navyData.path,'DODC3300','AcousticSensor','acousticData_dodc3301.mat'));
% load(fullfile(fdata.navyData.path,'DODC3300','TDAS','DODC3301','allddata.mat')) % mech *.x, *.head


if strcmpi(strInput,'mech')
    mech = true;
elseif strcmpi(strInput,'acoustic')
    mech = false;
else
    error('Incorrect string input... Should be either ''mech'' or ''acoustic''.')
end

if IDnum<4700
    % For all datasets between 2900 and 3400 (those are the sets on my mac)
    fullfile(['~/Documents/project_acousticSensorAnalysis/data/PMHS/
else
    
end