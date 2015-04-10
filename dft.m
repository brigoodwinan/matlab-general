function out = dft(in,n,dim)
% out = dft(in)
% out = dft(in,n)
% out = dft(in,n,dim)
% out = dft(in,[],dim)
%
% Brian Goodwin 2015-04-10
%
% Performs discrete fourier transform in the appropriate way:
%
% H = dft(h) is equivalent to H = fftshift(fft(ifftshift(h)));
%
% n (optional) is the length of the dft.
% dim (optional) indicates the dimension to apply the ifft on.
%
% see http://www.mathworks.com/matlabcentral/newsreader/view_thread/285244

if nargin>1
    if nargin>2
        out = fftshift(fft(ifftshift(in),n,dim));
    else
        out = fftshift(fft(ifftshift(in),n));
    end
else
    out = fftshift(fft(ifftshift(in)));
end