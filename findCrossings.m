function I = findCrossings(s,th,mode)
% I = findCrossings(s,th,mode)
%
% Brian Goodwin 2015-07-17
%
% Finds the points at which the signal rises above the threshold specified
% in "th". Crossings can be specified as 'up' (rising above threshold),
% 'down' (falling below threshold), 'peaks' (find local maxima), or
% 'valleys' (find local minima).
%
% INPUTS:
% s: input signal (n-by-1 or n-by-m where m is the number of signals).
% th: threshold value for crossings (scalar)
% mode: a string that specifies the nature of the output:
%         'up' - finds the points where the signal rises above threshold.
%         'down' - finds the points where the signal falls below threshold.
%         'peaks' - finds local maxima above the threshold.
%         'valleys' - finds local minima below the threshold.
%
% OUTPUTS:
% I: logical array indicating the indices in signal "s" that pertain to the
%      specified "mode".

if strcmpi(mode,'up')
    I = s(2:end,:)>th & s(1:end-1,:)<th;
    I = cat(1,false(1,size(I,2)));
elseif strcmpi(mode,'down')
    I = s(2:end,:)<th & s(1:end-1,:)>th;
    I = cat(1,false(1,size(I,2)));
elseif strcmpi(mode,'peaks')
    up = findCrossings(s,th,'up');
    down = findCrossings(s,th,'down');
    
end