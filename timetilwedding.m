function out = timetilwedding()
d = datenum(2013,12,14,13,30,0)-now;
day = floor(d);
hour = rem(d,1)*24;
hr = floor(hour);
minu = rem(hour,1)*60;
mn = floor(minu);
sec = rem(minu,1)*60;
s = floor(sec);
out = [day,hr,mn,s];

fprintf('\n%2.0f days, %02d:%02d:%02d\n\n',out);