function [sRMS,mn,roc,cutoffs] = evaluateEffectsOfCutoffFreq(inSig,DT,cutoffs,plotResult)
% [sRMS,mn,roc,cutoffs] = evaluateEffectsOfCutoffFreq(inSig,DT,cutoffs,plotResult)
%
% Brian Goodwin 2016-06-30
%
% Computes the RMS Error between the raw signals and filtered signals and
% also provides the rate of change of the RMS error as the cutoff frequency
% is decreased. This function works best when there are 3 or more input
% signals provided in n-by-(>=3) column vectors or in cells.
%
% Filters are generated using [b,a] = butter(2,cutoff/(FS/2));
%
% INPUTS:
% inSig: n-by-m column vector of signal(s) where m is equal to the number
%     of signals and n is the number of samples.
% DT: (optional) timestep (FS = 1/DT; used for determing cutoff 
%     frequencies). (default = 0.5 so that 100 cutoffs are tested between
%     0.01 and 0.5)
% cutoffs: (optional) list (array or vector) of cutoff frequencies. Leave 
%     empty for default. (default = linspace(0.01*(FS/2),0.5*(FS/2),100))
% plotResult: (optional) If evaluated as true, the result is automatically 
%     plotted. If false, no plot is generated. (default = false)
%
% OUTPUS:
% mn: normalized mean curve of RMS error over all signals
% roc: normalized rate of change of the mn curve as cutoff frequency is 
%     decreased.
% cutoffs: output of cutoff frequencies used in computing RMS error.
% sRMS: 

% Use the following for Debugging...
%{
s = randn(1000,20);
sRMS = evaluateEffectsOfCutoffFreq(s);
% or
evaluateEffectsOfCutoffFreq(s,[],[],1);
%}

% DT
if nargin<2 || isempty(DT)
    DT = 0.5;
end
FS = 1/DT;

% cutoffs
if nargin<3 || isempty(cutoffs)
    cutoffs = linspace(0.01,0.5,100); % cutoffs (kHz)
end

n = numel(cutoffs);
b = zeros(n,3);
a = b;

for k = 1:n
    [b(k,:),a(k,:)] = butter(2,cutoffs(k)/(FS/2)); % 900 Hz filter
end

if iscell(inSig)
    N = numel(inSig);
    for k = 1:N
        sRMS = zeros(n,N);
        for j = 1:n
            xf = filtfilt(b(j,:),a(j,:),inSig{k});
            sRMS(j,k) = sqrt(mean((xf-inSig{k}).^2));
        end
    end
else
    sRMS = zeros(n,size(inSig,2));
    for j = 1:n
        xf = filtfilt(b(j,:),a(j,:),inSig);
        sRMS(j,:) = sqrt(mean((xf-inSig).^2));
    end
end

sRMS = bsxfun(@rdivide,sRMS,sRMS(1,:));
mn = mean(sRMS,2);
roc = flipud(diff(flipud(mn)));
roc(n) = roc(n-1);
roc = roc./max(abs(roc));


if nargin==4 && ~isempty(plotResult)
    if plotResult
        figure
        plot(cutoffs,mn,'k','linewidth',1)
        hold on
        xlabel('Cutoff Frequency')
        ylabel('RMS Error')
        plot(cutoffs,roc,'r')
        legend('Mean RMS Error','RMS Error Rate of Change')
        plot(cutoffs,sRMS,'color',[zeros(1,3),0.2],'linewidth',0.5)
        
        
        xlabel('Cutoff Frequency')
        ylabel('RMS Rate of Change')
        ylim([min([sRMS(:);roc(:)]),1])
    end
end

