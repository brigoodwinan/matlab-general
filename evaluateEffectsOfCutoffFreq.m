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
%     inSig can also be a cell, which can be desirable if the signals in
%     question have different lengths.
% DT: (optional) timestep (FS = 1/DT; used for determing cutoff 
%     frequencies). (default = 0.5 so that 100 cutoffs are tested between
%     0.01 and 0.5)
% cutoffs: (optional) list (array or vector) of cutoff frequencies. Leave 
%     empty for default. (default = linspace(0.01*(FS/2),0.5*(FS/2),100))
% plotResult: (optional) If evaluated as true, the result is automatically 
%     plotted. If false, no plot is generated. Note that the result will be
%     plotted in the active figure window. For example, it is best to call
%     >> figure before running function with plot generation. (default = 
%     false) 
%
% OUTPUS:
% mn: normalized mean curve of RMS error over all signals
% roc: normalized rate of change of the mn curve as cutoff frequency is 
%     decreased.
% cutoffs: output of cutoff frequencies used in computing RMS error.
% sRMS: RMS of the filtered signal compared to the original unfiltered
% signal.
%
% e.g.,
% figure
% evaluateEffectsOfCutoffFreq(s,DT,cutoffs,1);

% Use the following for Debugging...
%{
% s = randn(1000,20);
s = cell(10,2);
for k = 1:numel(s)
    s{k} = randn(100000,ceil(rand*4));
end
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
    [b(k,:),a(k,:)] = butter(2,cutoffs(k)/(FS/2));
end


if iscell(inSig) % If the input is a cell:
    N = numel(inSig);
    
    if isPoolOpen % If parallel pool is open, use it.
        sRMS = cell(1,N);
        for k = 1:N
            tmp = zeros(n,size(inSig{k},2));
            insig = inSig{k};
            parfor j = 1:n
                xf = filtfilt(b(j,:),a(j,:),insig);
                tmp(j,:) = sqrt(mean((xf-insig).^2));
            end
            sRMS{k} = tmp;
        end
        sRMS = cell2mat(sRMS);
    else % if parallel pool is not open, run classic for loop.
        m = cellfun('size',inSig,2); % number of signals in each cell.
        msum = zeros(N+1,1);
        msum(2:N+1) = cumsum(m(:));
        sRMS = zeros(n,sum(m(:)));
        for k = 1:N
            for j = 1:n
                xf = filtfilt(b(j,:),a(j,:),inSig{k});
                sRMS(j,msum(k)+1:msum(k+1)) = sqrt(mean((xf-inSig{k}).^2));
            end
        end
    end
    
else % If the input signal is not a cell:
    sRMS = zeros(n,size(inSig,2));
    if isPoolOpen % If parallel pool is open, use it.
        parfor j = 1:n
            xf = filtfilt(b(j,:),a(j,:),inSig);
            sRMS(j,:) = sqrt(mean((xf-inSig).^2));
        end
    else % If parallel pool is not open, run classic for loop.
        for j = 1:n
            xf = filtfilt(b(j,:),a(j,:),inSig);
            sRMS(j,:) = sqrt(mean((xf-inSig).^2));
        end
    end
end

sRMS = bsxfun(@rdivide,sRMS,sRMS(1,:));
mn = mean(sRMS,2);
roc = flipud(diff(flipud(mn)))./flipud(diff(flipud(-cutoffs')));
roc(n) = roc(n-1);
roc = roc./max(abs(roc));


if nargin==4 && ~isempty(plotResult)
    if plotResult
        % figure
        plot(cutoffs,mn,'k','linewidth',2)
        hold on
        xlabel('Cutoff Frequency')
        ylabel('Normalized RMS Error')
        plot(cutoffs,roc,'r')
        legend('Mean RMS Error','RMS Error Rate of Change')
        plot(cutoffs,sRMS,'color',[zeros(1,3),0.2],'linewidth',0.5)
        ylim([min([sRMS(:);roc(:)]),1])
        plot(cutoffs,mn,'k','linewidth',2)
        hold off
    end
end

