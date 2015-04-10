function testDataStruct = readTLF3(TLFFileLoc)
    
    [path,name,ext] = fileparts(TLFFileLoc);
    testInfoStruct.TestID = name;
    testInfoStruct.FileName = [name ext];
    testInfoStruct.FilePath = path;
    
    fid = fopen(TLFFileLoc,'r');
    
    testInfoStruct.tdasVer = fgetl(fid); %read Line 1
    testInfoStruct.FileDescription = fgetl(fid); %read Line 2
    testInfoStruct.TestDate = fgetl(fid); %read Line 3
    testInfoStruct.TestTime = fgetl(fid); %read Line 4
    testInfoStruct.TestDescp = fgetl(fid); %read Line 5
    
    %% Read Sampling Information
    
    if strcmp(fgetl(fid),'---- Start Sampling Information ----')==1
        filePos = ftell(fid); %get the current file pointer
        if strcmp(fgetl(fid),'---- End Sampling Information ----')==1
            disp('No Sampling Info')
            junk=fgetl(fid); %End sampling info
        else
            fseek(fid,filePos,'bof'); %Put the point back to reading the line
            disp('Reading Sampling info');
            samplingHeader = fgetl(fid);
            samplingValues = fgetl(fid);
            junk=fgetl(fid); %End sampling info
        end
    end
    
    samplingHeader=textscan(samplingHeader,'%s','Delimiter',',');
    samplingHeader = samplingHeader{1};
    
    samplingValues=textscan(samplingValues,'%d','Delimiter',',');
    samplingValues = samplingValues{1};
    
    if length(samplingValues) ~= length(samplingHeader)
        samplingValues(end+1) = NaN;
    end
    
    
    
    %% Read Rack Information
    
    if strcmp(fgetl(fid),'---- Start Rack Information ----')==1
        filePos = ftell(fid); %get current file pointer
        if strcmp(fgetl(fid),'---- End Rack Information ----')==1
            disp('No Rack Info');
            junk=fgetl(fid); %End Rack info
        else
            fseek(fid,filePos,'bof');
            disp('Reading Rack info');
            filePos = ftell(fid);
            rackHeader = fgetl(fid);
            nextLine=fgetl(fid);
            index=1;
            rackValues={};
            while strcmp(nextLine,'---- End Rack Information ----') ~=1
                rackValues{index} = nextLine;
                nextLine=fgetl(fid);
                index=index+1;
                filePos=ftell(fid);
            end
            
            %rackHeader = fgetl(fid);
            %rackValues = fgetl(fid);
            %junk=fgetl(fid); %End rack info
        end
    end
    
    rackHeader=textscan(rackHeader,'%s','Delimiter',',');
    rackHeader = rackHeader{1};
    
    for i = 1:length(rackValues)
        rackValues(i)=textscan(rackValues{i},'%s','Delimiter',',');
    end
    
    
    %if length(rackValues) ~= length(rackHeader)
    %    rackValues(end+1) = NaN;
    %end
    
    %% Read Module Information
    %---- Start Module Information ----
    if strcmp(fgetl(fid),'---- Start Module Information ----')==1
        filePos = ftell(fid); %get current file pointer
        if strcmp(fgetl(fid),'---- End Module Information ----')==1
            disp('No Module Info');
            junk=fgetl(fid); %End Rack info
        else
            fseek(fid,filePos,'bof');
            disp('Reading Module info');
            filePos = ftell(fid);
            moduleHeader = fgetl(fid);
            nextLine=fgetl(fid);
            index=1;
            moduleInfo={};
            while strcmp(nextLine,'---- End Module Information ----') ~= 1
                moduleInfo{index} = nextLine;
                nextLine = fgetl(fid);
                index=index+1;
                filePos = ftell(fid);
            end
        end
    end
    
    moduleHeader=textscan(moduleHeader,'%s','Delimiter',',');
    moduleHeader = moduleHeader{1};
    
    for i=1:length(moduleInfo)
        moduleInfo(i)=textscan(moduleInfo{i},'%s','Delimiter',',');
    end
    
    
    %% Read Sensor Channel Information
    
    if strcmp(fgetl(fid),'---- Start Sensor Channel Information ----')==1
        filePos = ftell(fid); %get current file pointer
        nextLine = fgetl(fid);
        if strcmp(nextLine,'---- End Sensor Channel Information ----')==1
            disp('No Module Info');
            junk=fgetl(fid); %End Rack info
            filePos = ftell(fid);
        else
            fseek(fid,filePos,'bof');
            filePos = ftell(fid);
            nextLine=fgetl(fid);
            
            if strcmp(nextLine,'PreTest Data')
                %Get Pre Test Data Info
                preTestHeader = fgetl(fid);
                preTestHeader = textscan(preTestHeader,'%s','Delimiter',',');
                preTestHeader=preTestHeader{1};
                
                
                
                channelInfoPre={};
                index=1;
                
                filePos = ftell(fid);
                nextLine = fgetl(fid);
                while strcmp(nextLine,'PostTest Data') ~= 1
                    channelInfoPre{index} = nextLine;
                    nextLine = fgetl(fid);
                    index=index+1;
                    filePos = ftell(fid);
                end
            end
            fseek(fid,filePos,'bof');
            filePos = ftell(fid);
            %nextLine=fgetl(fid);
            
            if strcmp(nextLine,'PostTest Data')
                %Get Pre Test Data Info
                postTestHeader = fgetl(fid);
                postTestHeader = textscan(postTestHeader,'%s','Delimiter',',');
                postTestHeader=postTestHeader{1};
                
                channelInfoPost={};
                index=1;
                
                filePos = ftell(fid);
                nextLine = fgetl(fid);
                while strcmp(nextLine,'---- End Sensor Channel Information ----') ~= 1
                    
                    
                    channelInfoPost{index} = nextLine;
                    nextLine = fgetl(fid);
                    index=index+1;
                    filePos = ftell(fid);
                end
            end
            
            
            
            
        end
    end
    
    %% Read Calculated Channel Information
    
    if strcmp(fgetl(fid),'---- Start Calculated Channel Information ----')==1
        filePos = ftell(fid); %get current file pointer
        if strcmp(fgetl(fid),'---- End Calculated Channel Information ----')==1
            disp('No Calculated Channel Info');
            junk=fgetl(fid); %End Rack info
        else
            fseek(fid,filePos,'bof');
            disp('Reading Calculated Channel info');
            filePos = ftell(fid);
            calChanHeader = fgetl(fid);
            calChanHeader = textscan(calChanHeader,'%s','Delimiter',',');
            calChanHeader=calChanHeader{1};
            nextLine=fgetl(fid);
            index=1;
            calChanInfo={};
            while strcmp(nextLine,'---- End Calculated Channel Information ----') ~= 1
                calChanInfo{index} = nextLine;
                nextLine = fgetl(fid);
                index=index+1;
                filePos = ftell(fid);
            end
        end
    end

   %Create channel with structure information
   dataStruct=[];
   preStructInfo = getInfoFromStruct(dataStruct,channelInfoPre,preTestHeader,'Pre',testInfoStruct);
   preAndPostStructInfo = getInfoFromStruct(preStructInfo,channelInfoPost,postTestHeader,'Post',testInfoStruct);
   preAndPostAndCalcStructInfo = getInfoFromStruct(preAndPostStructInfo,calChanInfo,calChanHeader,'Calc',testInfoStruct);
    
    testDataStruct = preAndPostAndCalcStructInfo';
end


function infoStruct = getInfoFromStruct(infoStruct,channelData,header,channelDataType,testInfoStruct)
    
    for i=1:length(channelData)
        channelInfo = textscan(channelData{i},'%s','Delimiter',',');
        channelInfo=channelInfo{1};
        structFieldNames = cellfun(@(x) x(isstrprop(x,'alphanum')),header,'UniformOutput',0);
        
        %See if field name starts with numeric and add letter if it does 
        r=~cellfun(@(x) isletter(x),cellfun(@(x) x(1:1),structFieldNames,'UniformOutput',0));
        structFieldNames(r) = cellfun(@(x) strcat('c' ,x),structFieldNames(r),'UniformOutput',0);
        channelInfo = channelInfo(1:length(structFieldNames)); %Trim to save length as field
        
        switch channelDataType
            case 'Pre'
                infoStruct{i}.Pre = cell2struct(channelInfo,structFieldNames);
                
                chanName = sprintf('%03d',str2num(infoStruct{i}.Pre.datachan));
                infoStruct{i}.ChanFileName = [testInfoStruct.TestID chanName '.Bin'];
                infoStruct{i}.ChanFilePath = [testInfoStruct.FilePath '\' infoStruct{i}.ChanFileName];
                infoStruct{i}.ChanDescp = infoStruct{i}.Pre.descrip;
                infoStruct{i}.Filter = str2num(infoStruct{i}.Pre.filter);
                infoStruct{i}.EU = infoStruct{i}.Pre.EU;
                
                infoStruct{i}.TestID = testInfoStruct.TestID;
                infoStruct{i}.TLFFileName = testInfoStruct.FileName;
                infoStruct{i}.TLFFilePath = testInfoStruct.FilePath;
                
                
                [timeArr,dataArr,aqRate,testID] = readBin(infoStruct{i}.ChanFilePath);
                
                infoStruct{i}.TimeArr = timeArr;
                infoStruct{i}.DataArr = dataArr;
                infoStruct{i}.AqRate = aqRate;
                
                
                CFC = infoStruct{i}.Filter;
                [B,A]=butter(2,(2.0775*CFC)/(infoStruct{i}.AqRate/2)); % 02Apr2014 M.Sch. changed 2.0 -> 2.0775 Ref. J211-95 AppC
                fy = filter(B,A,infoStruct{i}.DataArr);
                fy(end:-1:1,1) = filter(B,A,fy(end:-1:1,1));
                
                infoStruct{i}.FilteredDataArr = fy;
                
                
               
                
            case 'Post'
                infoStruct{i}.Post = cell2struct(channelInfo,structFieldNames);
            case 'Calc'
                calcIndx = length(infoStruct) + i;
                infoStruct{calcIndx}.Calc = cell2struct(channelInfo,structFieldNames);

                chanName = sprintf('_C%03d',str2num(infoStruct{calcIndx}.Calc.chan));
                infoStruct{calcIndx}.ChanFileName = [testInfoStruct.TestID chanName '.Bin'];
                infoStruct{calcIndx}.ChanFilePath = [testInfoStruct.FilePath '\' infoStruct{calcIndx}.ChanFileName];
                infoStruct{calcIndx}.ChanDescp = infoStruct{calcIndx}.Calc.descrip;
                %infoStruct{calcIndx}.Filter = str2num(infoStruct{calcIndx}.Pre.filter);
                infoStruct{calcIndx}.EU = infoStruct{calcIndx}.Calc.EU;
                
                infoStruct{calcIndx}.TestID = testInfoStruct.TestID;
                infoStruct{calcIndx}.TLFFileName = testInfoStruct.FileName;
                infoStruct{calcIndx}.TLFFilePath = testInfoStruct.FilePath;
                
                [timeArr,dataArr,aqRate,testID] = readCalcBin(infoStruct{calcIndx}.ChanFilePath);
                
                infoStruct{calcIndx}.TimeArr = timeArr;
                infoStruct{calcIndx}.DataArr = dataArr;
                infoStruct{calcIndx}.AqRate = aqRate;
                
        end
    end
    
    
    
    
end
   