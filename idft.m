function out = idft(in,n,dim)
% out = idft(in)
% out = idft(in,n)
% out = idft(in,n,dim)
% out = idft(in,[],dim)
%
% Brian Goodwin 2015-04-10
%
% Performs the inverse discrete fourier transform when of a DFT
%
% H = dft(h);
% h = idft(H);
% h == idft(dft(h));
%
% out = idft(in) is equivalent to out = fftshift(ifft(ifftshift(in)))
%
% n (optional) is the length 
% dim (optional) indicates the dimension to apply the dft on.
%
% see http://www.mathworks.com/matlabcentral/newsreader/view_thread/285244

if nargin>1
    if nargin>2
        out = fftshift(ifft(ifftshift(in),n,dim));
    else
        out = fftshift(ifft(ifftshift(in),n));
    end
else
    out = fftshift(ifft(ifftshift(in)));
end