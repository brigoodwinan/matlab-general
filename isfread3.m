function [rtnData, headData] = isfread3 (filename)
% isfread - will read the .ISF files produced by TEK MSO4000 oscilloscopes
%
% useage:   [rtnData, headData] = isfread ('filename')
% where:    rtnData     - is a struct with the x and y data returned in 
%                         rtnData.x and rtnData.y respectively 
%           headData    - is a struct with all the header data returned in
%                         different fields
%           'filename'  - is a string with the name of the file to be
%                         extracted
%
% Example:  filename = 'TEK00000CH1.ISF';
%           [data, header] = isfread (filename);
%           plot(data.x,data.y)
%
% The returned data is pre scaled using the information contained in the
% header of the ISF file.
%
% * Written 1/25/2009 by Wenwei Qiao *


fileID = fopen(filename,'r');

% read ASCII header
header_tmp = fread(fileID, 500)';
header = char(header_tmp);

headData = parseHead(header);

fseek(fileID, 0, 'eof');
dataOffset =  - headData.NR_PT*headData.BYT_NR;
fseek(fileID, dataOffset, 'cof');

if (headData.BYT_NR==1)
    inData = fread(fileID, headData.NR_PT, 'int8');
else
    inData = fread(fileID, headData.NR_PT, 'int16',  'ieee-be');
end

fclose(fileID);

lowerXLimit = headData.XZERO;
upperXLimit = ((headData.NR_PT-1)* headData.XINCR  + headData.XZERO);
rtnData.x   = [lowerXLimit : headData.XINCR : upperXLimit]';
rtnData.y   = headData.YMULT*(inData-headData.YOFF) + headData.YZERO;




% parseHead - used to parse and convert the header data into a more
% useful structure.
function headData = parseHead(header)

headData.NR_PT       = getParamNum(header, 'NR_PT'    ); 
headData.BYT_NR		= getParamNum(header, 'BYT_NR'	); 
headData.BIT_NR		= getParamNum(header, 'BIT_NR'	); 
headData.XINCR		= getParamNum(header, 'XINCR'	 	);
headData.XZERO		= getParamNum(header, 'XZERO'	 	);
headData.PT_OFF		= getParamNum(header, 'PT_OFF' 	);
headData.YMULT		= getParamNum(header, 'YMULT'  	);
headData.YOFF		= getParamNum(header, 'YOFF'  	);
headData.YZERO		= getParamNum(header, 'YZERO'  	);
headData.YSCALE		= getParamNum(header, 'YSCALE'	);
headData.HSCALE		= getParamNum(header, 'HSCALE'	);
headData.YPOS 		= getParamNum(header, 'YPOS'	);
headData.YOFFSET	= getParamNum(header, 'YOFFSET'	);
headData.HDELAY		= getParamNum(header, 'HDELAY'	);
headData.VSCALE     = getParamNum(header, 'VSCALE'	);
headData.HSCALE     = getParamNum(header, 'HSCALE'	);
headData.VPOS     = getParamNum(header, 'VPOS'	);
headData.VOFFSET     = getParamNum(header, 'VOFFSET'	);
headData.DOMAINTIME     = getParamNum(header, 'DOMAIN TIME'	);
headData.WFMTYPE     = getParamNum(header, 'WFMTYPE'	);
headData.CENTERFREQ     = getParamNum(header, 'CENTERFREQUENCY'	);
headData.SPAN     = getParamNum(header, 'SPAN'	);
headData.REFLEVEL     = getParamNum(header, 'REFLEVEL'	);

headData.ENCDG        = getParamStr(header, 'ENCDG',   ';');
headData.BN_FMT       = getParamStr(header, 'BN_FMT',  ';');
headData.BYT_OR      = getParamStr(header, 'BYT_OR', ';');
headData.WFID        = getParamStr(header, 'WFID',   '"');
headData.PT_FMT       = getParamStr(header, 'PT_FMT',  ';');
headData.XUNIT        = getParamStr(header, 'XUNIT',   '"');
headData.YUNIT        = getParamStr(header, 'YUNIT',   '"');

headData.CURV       = getCurvNum(header);

function rtnNum = getParamNum (headStr, cmdStr)
cmdLoc = findstr(headStr, cmdStr);
if (cmdLoc)
    headStr_tmp     = headStr(cmdLoc(1)+length(cmdStr)+1 : length(headStr)) ;
    [tmp, remJunk]  = strtok(headStr_tmp,';') ;
    rtnNum          = str2num(tmp);
else
    rtnNum =[];
end


function rtnStr = getParamStr(headStr, cmdStr, dlm)
cmdLoc = findstr(headStr, cmdStr);
if (cmdLoc)
    headStr_tmp     = headStr(cmdLoc(1)+length(cmdStr)+1 : length(headStr)) ;
    [rtnStr,remStr] = strtok(headStr_tmp, dlm) ;
else
    rtnStr=[];
end


function rtnNum = getCurvNum (headStr)
cmdStr='CURV #';
cmdLoc = findstr(headStr, cmdStr);
if (cmdLoc)
    headStr_tmp     = headStr(cmdLoc(1)+length(cmdStr) : length(headStr)) ;
    curvNum_tmp     = headStr_tmp(1);
    curvNum         = str2num(curvNum_tmp);
    tmp             = headStr_tmp(2:curvNum+1) ;
    rtnNum          = str2num(tmp);
else
    rtnNum=[];
end


