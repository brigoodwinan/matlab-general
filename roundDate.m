function out = roundDate(in,fixToNearest)
% out = roundDate(in,fixToNearest)
%
% Brian Goodwin 2015-12-07
%
% Rounds matlab time number to the nearest number of minutes.
%
% INPUTS:
% in: a vector or number of matlab date numbers that are to be fixed to
%      the nearest number of minutes.
% fixToNearest: an integer of the number of minutes to round to. For
%      example, if roundToNearest = 15, then "out" will have all date
%      numbers in 15 min increments.
%
% OUTPUTS:
% out: fix(in*24/(fixToNearest/60))*(fixToNearest/60)/24. The
%      changed input were each date number is in increments of
%      "fixToNearest"

out = fix(in*24/(fixToNearest/60))*(fixToNearest/60)/24;
