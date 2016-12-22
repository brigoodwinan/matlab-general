% RCFILT Allows the inputs of Resistance, Capacitance, filter type, 
% sampling rate, and wave form to create an RC filter to simulate the 
% characteristics of an electrode on the cortical surface.
% 
% RCFILT(R,C,Type,fs,wf)
% 
% R    = Resistance [Ohm]
% C    = Capacitance [F]
% Type = Filter type.  Either High or Low pass filter:
%           1 = High pass
%           0 = Low pass
% fs   = Sampling frequency [s^-1]
% wf   = Wave form [V]
%       An nx1 vector corresponding to fs.  Can be created using gensig.  
%       Example:
%       wf=gensig('square',Period,Length,1/fs);
% 
% This function uses the discrete (z-domian) transfer function with zero
% order hold for either the high or low pass filter (RC circuit) to produce
% the time response transformed from the continuous (s) domain:
% Low:   Vo/Vi=1/(RCs+1)
% High:  Vo/Vi=RCs/(RCs+1)

function [y,T] = rcfilt(R,C,pass,fs,wf)

Ts=1/fs;
%Analog
if pass
    %High pass
    num=[R*C,0];
    den=[R*C,1];
    %Cutoff frequency
    %fc=1/2/pi/R/C;
elseif ~pass
    %Low pass
    num=1;
    den=[R*C,1];
else
    disp('Incorrect input')
    return
end

%analog
sysc = tf(num,den);

%continuous to digital
sysd = c2d(sysc,Ts,'zoh');


%Time response
figure
t=0:Ts:numel(wf)*Ts-Ts;
[y,T]=lsim(sysd,wf,t);
plot(T,y,'k',t,wf,'--r')

title('Time Response vs. Waveform input')
legend('Time Response','Waveform input','SouthEast')
xlabel('Time [s]')
ylabel('Voltage Out [V]')
grid on