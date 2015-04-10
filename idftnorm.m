function out = idftnorm(in)
% out = idft(in)
%
% Brian Goodwin 2015-04-10
%
% Performs the inverse discrete fourier transform when of a DFT, but 
% produces a normalized output, i.e. norm(out) = norm(in)
%
% H = dft(h);
% h = idft(H);
%
% see http://www.mathworks.com/matlabcentral/newsreader/view_thread/285244

out = fftshift(ifft(ifftshift(in))).*sqrt(length(in));