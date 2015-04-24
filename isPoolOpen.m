function out = isPoolOpen()
% Returns logical value if matlab parallel processing is open and ready.
% isPoolOpen
%
% Brian Goodwin
%
% 1 if matlabpool has been opened, 0 if not.

tmp = version('-release');
tmp = str2double(tmp(1:4));

if tmp<2014
    out = matlabpool('size')>0;
else
    out = ~isempty(gcp('nocreate'));
end