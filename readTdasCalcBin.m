function [timeArr ,dataArr, aqRate, testID] = readCalcBin(varargin)
    
    try
        load previousPath
    catch
        fileFolder = 'C:\';
    end
    
    switch nargin
        case 0
            [fileName ,fileFolder] = uigetfile([fileFolder '*.BIN'],'Select File');
            
        case 1
            [fileFolder, fileName, ext] = fileparts(varargin{1});
            fileName = [fileName ext];
    end
    
    [~ ,testID]=fileparts(fileName);
    
    filePath = fullfile(fileFolder,fileName);
    save previousPath fileFolder;
    [fid,errmsg]=fopen(filePath,'r');
    
    if fid == -1
        uiwait(warndlg(errmsg));
        return;
    end
    
    fileID = fid;
    
    aqRate = fread(fileID,1, 'double');
    PreZero =  fread(fileID,1, 'int');
    PostZero = fread(fileID,1, 'int');
    inData = fread(fileID,PreZero+PostZero, 'double');
    
    fclose(fileID);
    Time = (-PreZero:PostZero-1)/aqRate;
    
    timeArr = Time';
    dataArr = inData;
    %plot(Time, inData);
end