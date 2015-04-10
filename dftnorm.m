function out = dftnorm(in)
% out = dftnorm(in)
% 
% Brian Goodwin 2015-04-10
%
% Performs discrete fourier transform in the appropriate way, but produces
% a normalized output, i.e. norm(out) = norm(in)
%
% see http://www.mathworks.com/matlabcentral/newsreader/view_thread/285244

out = fftshift(fft(ifftshift(in)))./sqrt(length(in));