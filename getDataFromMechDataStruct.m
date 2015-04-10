function [out,t] = getDataFromMechDataStruct(mech,hdrDataString)
% out = getDataFromMechDataStruct(mech,hdrDataString)
%
% Brian Goodwin 2015-03-24
%
% Retreives data from mech data structure (mech.x; mech.head) given a
% string that describes the data to be retrieved.
%
% INPUTS:
% mech: a structure with the fields "x" and "head"
% hdrDataString: a string describing the data to be retrieved. 
%      e.g. 'L1 strain'
%
% OUTPUTS:
% out: n-by-1 vector array of desired data
% t: (optional) n-by-1 vector array of the time from the mech data
%      strcuture.

ind = getIndexFromMechDataFile(mech.head,hdrDataString);

out = mech.x(:,ind);
if nargout>1
    t = mech.x(:,1);
end