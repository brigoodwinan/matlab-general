function [ST,G] = stran(h)
% function ST = stran(h)

% ST = stran(h)
%
% Coded by Kalyan S. Dash
% Edited, Brian Goodwin, 2015-02-24
%
% 2015-04-08 - v2 (working version)
%
% Compute S-Transform without for loops
%
% BDG Edits use parfor loops or for loops
%
% "h" is 1xN or Nx1 one-dimensional series
%
% v1 Notes
% Uses no for loops
%
% v2 Notes
% Uses parfor or for loops and makes the fft using nextpow2() function.

%
[~,n] = size(h); % h is a 1xN one-dimensional series

if n==1
    h = h.';
    n = length(h);
end

n = pow2(nextpow2(n));

nhalf = n/2;

% Hft = fft(h);
Hft = fft(h,n);

% Compute Toeplitz matrix with the shifted fft(h)
HW = toeplitz(Hft(1:nhalf+1)',Hft);
f = ifftshift((-nhalf:nhalf-1))./n;

% Compute all frequency domain Gaussians as one matrix
invfk = 1./f(2:nhalf+1).';
W = 2*pi*(invfk*f); % BDG edit 2015-02-24 
G = exp((-W.^2)/2); %Gaussian in freq domain

% Exclude the first row, corresponding to zero frequency
HW = HW(2:end,:);

% Compute Stockwell Transform
ST = ifft(HW.*G,[],2); %Compute voice

% Add the zero freq row
st0 = mean(h)*ones(1,n);

% ST = [st0;ST]; % bdg edit 2015-04-02
ST = cat(1,st0,ST);

end
%

%{
% Compute S-Transform without for loops

%%% Coded by Kalyan S. Dash %%%
%%% IIT Bhubaneswar, India %%%

[~,N]=size(h); % h is a 1xN one-dimensional series

nhaf=fix(N/2);

odvn=1;

if nhaf*2==N;
    odvn=0;
end

f=[0:nhaf -nhaf+1-odvn:-1]/N;

Hft=fft(h);

%Compute all frequency domain Gaussians as one matrix

invfk=[1./f(2:nhaf+1)]';

W=2*pi*repmat(f,nhaf,1).*repmat(invfk,1,N);

G=exp((-W.^2)/2); %Gaussian in freq domain

% End of frequency domain Gaussian computation

% Compute Toeplitz matrix with the shifted fft(h)

HW=toeplitz(Hft(1:nhaf+1)',Hft);

% Exclude the first row, corresponding to zero frequency

HW=[HW(2:nhaf+1,:)];

% Compute Stockwell Transform

ST=ifft(HW.*G,[],2); %Compute voice

%Add the zero freq row

st0=mean(h)*ones(1,N);

ST=[st0;ST];

end
%}