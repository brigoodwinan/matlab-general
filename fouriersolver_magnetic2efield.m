function [wave,v_fft] = fouriersolver_magnetic2efield(wv,dt,v,fsol)
% wave = fouriersolver_magnetic2efield(sourcewave,dt,solution,fsol)
% [wave,wave_fft] = fouriersolver_magnetic2efield(sourcewave,dt,solution,fsol)
%
% Brian Goodwin 2014-09-01
%
% Given the electric solution from a magnetic source in purely resistive
% medium from a given frequency, solves for the output wave in time. 
%
% e.g. TMS waveform
%
% INPUTS:
% sourcewave: waveform of the magnetic source (n-by-1)
% dt: timestep of the sourcewave
% solution: Fourier component solution (complex number). Normally purely
%       imaginary. e.g. 1i
% fsol: frequency from which the solution was obtained
%
% OUTPUTS:
% wave: time-dependent waveform of the output given the input source wave
%       and the solution.
% wave_fft: (optional) the single sided fft of the output waveform.

fs = 1/dt;

N = length(wv);
n = 2^nextpow2(N);
if n<16384
    n = 16384; 
end

N = n/2+1;
H = fft(wv,n)/n;
H = H(1:N).*[1;2*ones(N-2,1);1]; % single sided.

phi = angle(v)+angle(H); % new phase 

finc = fs/n; % Freq increment
f = (0:n-1)*finc; % frequencies

F = f(1:n/2+1)'; % positive frequencies
v = abs(v).*F/fsol; % frequency scaling
v = v.*abs(H);

v = complex(v.*cos(phi),v.*sin(phi));
v(1) = real(v(1));
v(end) = real(v(end));
v_fft = v;
v(2:end-1) = v(2:end-1)/2;
v = [v;flipud(conj(v(2:end-1)))]*n;
v_t = ifft(v);

wave = v_t(1:length(wv));