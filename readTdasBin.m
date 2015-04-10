function [timeArr ,dataArr, aqRate] = readTdasBin(fileWithPath)
% Modified by Brian Goodwin 2015-03-17

if nargin<1
    [fileName ,fileFolder] = uigetfile('*.BIN','Select File');
    fileWithPath = fullfile(fileFolder,fileName);
end

[fid,errmsg] = fopen(fileWithPath,'r');

if fid == -1
    uiwait(warndlg(errmsg));
    return;
end

fileID = fid;

aqRate = fread(fileID,1, 'double');
PreZero =  fread(fileID,1, 'int');
PostZero = fread(fileID,1, 'int');
fread(fileID,1, 'int');
fread(fileID,1, 'int');
fread(fileID,1, 'double');
fread(fileID,1, 'int');
fread(fileID,1, 'int');
DataZero = fread(fileID,1, 'int');
fread(fileID,1, 'double');
ScaleFact = fread(fileID,1, 'double');
y = fread(fileID,PreZero+PostZero, 'int16');
dataArr=(y-DataZero)*ScaleFact;
fclose(fileID);
timeArr = [(-PreZero:PostZero-1)/aqRate]';







%{
aqRate = fread(fid,1,'double');
fseek(fid,8,'bof');

numPreTZero = fread(fid,1,'int');
fseek(fid,12,'bof');

numPostTZero = fread(fid,1,'int');
fseek(fid,16,'bof');

preZeroLevel = fread(fid,1,'int');
fseek(fid,20,'bof');

preCalcLevel = fread(fid,1,'int');
fseek(fid,24,'bof');

StoNRatio = fread(fid,1,'double');
fseek(fid,32,'bof');

postZeroLevel = fread(fid,1,'int');
fseek(fid,36,'bof');

postCalLevel = fread(fid,1,'int');
fseek(fid,40,'bof');

dataZeroLevel = fread(fid,1,'int');
fseek(fid,44,'bof');

scaleFactorMv = fread(fid,1,'double');
fseek(fid,52,'bof');

scaleFactorEU = fread(fid,1,'double');
fseek(fid,60,'bof');

data = (fread(fid,inf,'int16'));
%timeArr =
%data=reshape(data,[16000 16000]);


dataScaled = (data-dataZeroLevel) * scaleFactorEU;
%fseek(fid,32,'bof')
dataArr=dataScaled;

timeArrPre = -(numPreTZero/aqRate):(1/aqRate):0;
timeArrPre(1)=[];
timeArrPost = 0:(1/aqRate):(numPostTZero/aqRate);
timeArrPost(end)=[];
timeArr=[timeArrPre timeArrPost];
timeArr=timeArr';
%}