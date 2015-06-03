function out = getBoneFractureDataFileName(in)
% out = getBoneFractureDataFileName(in)
%
% Brian Goodwin, 2015-06-03
%
% Returns a string that is the filename of an experiment. The input is the
% experiment number.
%
% e.g., in = 3 corresponds to out = 'exp3'

out = ['exp',num2str(in)];