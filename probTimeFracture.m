function out = probTimeFracture(inSignal,t,options)
% out = probTimeFracture(inSignal)
%
% Brian Goodwin 2015-03-20
%
% Computes the time-probability curve to quantify the probability that a
% fracture/injury occurs.
%
% INPUTS:
% inSignal: acoustic sensor signal (n-by-numChannels). numChannels is the
%       number of acoustic signals. If only one channel, then inSignal is
%       n-by-1.
% t: (optional) n-by-1 vector of the time-stamp for each point in inSignal.
% options (optional): a structure with the following optional inputs.
%       .overlap: a number between 1 and 0 indicating the fraction of
%           overlap of the window size. Default is 0.80.
%       .windowSize: integer value of the size of the window. The default
%           value is 2.5e-3 sec window where fs = 5e6 Hz (12500).
%
% OUTPUTS:
% out: a structure with the fields *.t and *.p where out.t is the time (if
%       provided) and out.p is the probability of fracture/injury over
%       time. NOTE: if 't' is not provided (i.e., t = []), the probability
%       curve is the same length as inSignal. Otherwise, out.p will be
%       smaller in length due to the window overlap.

% Debugging Purposes
%{
inSignal = randn(1000,1);
[n,m] = size(inSignal);
t = 1:1000; t = t*1e-3;
options.overlap = 0.80;
options.windowSize = 49; % purposefully odd to test workability.
%}

%
if nargin>2
    if ~isfield(options,'overlap')
        options.overlap = 0.90;
    end
    if ~isfield(options,'windowSize')
        options.windowSize = 12500;
    end
else
    options = struct('windowSize',12500,'overlap',0.90);
end
%

if ~isPoolOpen
    warning('Parpool (or matlabpool) is not turned on. To speed up processing speed, turn matlabpool (or parpool) on.');
end

winSize = options.windowSize;

overlapInc = floor(options.windowSize*(1-options.overlap));

numProcess = floor(winSize/overlapInc)-1;

dt = t(2)-t(1);
% peakArea = [120,135]; % [us]
peakArea = 5:10;
out = cell(1,numProcess);
totWindows = floor(n./winSize);

for k = 1:numProcess
    strt = (k-1)*overlapInc+1;
    nWindows = floor((n-strt+1)/winSize);
    fin = nWindows*winSize;
    probWindows = mat2cell(inSignal(strt:fin+strt-1),repmat(winSize,1,nWindows),1);
    ptmp = zeros(totWindows,1);
    ptmp = num2cell(ptmp);
    
    if isPoolOpen
        parfor kk = 1:nWindows
            ptmp{kk} = mainForLoopProbTimeFracture(probWindows{kk},winSize,peakArea);
        end
    else
        for kk = 1:nWindows
            ptmp{kk} = mainForLoopProbTimeFracture(probWindows{kk},winSize,peakArea);
        end
    end
    
    out{k} = cell2mat(ptmp);
    
end

cellfun(@length,out);
out = cell2mat(out).';
out = reshape(out,1,numel(out));

return
% Plotting for debugging
%{
stem(p,'marker','none')
%}

% psuedocode
% copmute the probability

% resample the probability curve to match the time curve.
end

%% Main for loop function
function out = mainForLoopProbTimeFracture(probWindows,winSize,peakArea)
tmp = xcorr(probWindows,'coeff');
tmp = tmp(winSize:2*winSize-1);
tmp = abs(rceps(tmp));
out = mean(tmp(peakArea));
return
end