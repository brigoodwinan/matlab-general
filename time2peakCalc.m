function out = time2peakCalc(in,maSize)
% out = time2peakCalc(in)
% out = time2peakCalc(in,maSize)
%
% Brian Goodwin 2016-09-01
%
% Computes the time to peak using a moving average technique. This
% technique was developed to avoid error from velocity (integral of
% acceleration) traces that would never "reach the peak."
%
% The algorithm takes the absolute value of the signal, computes the moving
% average, subtracts the moving average from the signal, and then finds the
% location of the maximum value of the signal. The length of the moving
% average (in samples) can be provided if desired (default = 100).
% 
% INPUTS:
% in: input signal (n-by-1 or n-by-m, where m is the number of signals).
%     Signals are provided in column vector form.
% maSize: integer indicating the number of samples in the moving average;
%     i.e., the moving average length or moving average period.
% 
% OUTPUTS:
% out: the sample at which the peak occurs (integer).

if nargin<2
    maSize = 100;
end

[~,out] = max(abs(in) - filter(ones(maSize,1)/maSize,1,abs(in)));