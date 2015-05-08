function out = vclmAcousticDelay(folderNum)
% out = vclmAcousticDelay(folderNum)
%
% Brian Goodwin 2015-05-07
%
% Put in the folder number and the output is the delay in the acoustic
% signal. In otherwords, the time stamps for the recordings should be added
% (???) to the timestamps.

switch folderNum
    case 22
        out = 5;
    case 24
        out = 3.11;
    case 26
        out = 3.07;
    case 30
        out = 2.5;
    case 33
        out = 18.14;
    case 34
        out = 11.21;
    case 36
        out = 8.01;
    case 38
        out = 5.73;
    case 39
        out = 6.98;
    case 41
        out = 4.37;
    case 43
        out = 3.21;
    case 45
        out = 2.01;
    case 46
        out = 52.6;
    case 51
        out = 18.38;
    case 53
        out = 13.81;
    case 55
        out = 43.16;
    case 57
        out = 18.63;
    case 60
        out = 12.99;
%         out = 64.01;
    case 66
        out = 6.69;
    otherwise
        out = 0;
        disp(['No delay found for VCLM ',num2str(folderNum)])
end
out = out*1e-3;
return
end