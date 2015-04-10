function out = getIndexFromMechDataFile(hdr,hdrDataString)
% out = getIndexFromMechDataFile(hdr,hdrDataString)
% 
% Brian Goodwin, 2015-03-24
%
% Retreives index from header (normally "mech.head") given a cell string 
% that contains the name of the data you wish to retreive.

out = find(strncmpi(hdrDataString,hdr,length(hdrDataString)))+1;