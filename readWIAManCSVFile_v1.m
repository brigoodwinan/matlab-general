function dat = readWIAManCSVFile(filename,minrow,maxrow)
warning('Do not use this file unless the data is arranged in the order it is listed in the m-file.')
%
% dat = readWIAManCSVFile(filename,minrow,maxrow)
% dat = readWIAManCSVFile(filename)
%
% Brian Goodwin, 2015-02-19
%
% Reads in Army Man files that typically are named something like...
% '08-003 unfiltered data 03Jul14 10-25-57.csv'.
%
% Must enter in full string of file and specify the minimum row (normally
% 9) and maximum row (around 21052). Assuming that the columns contain the
% data and are labeled as follows (From A-L):
%
% time (sec);
% T1 linear acceleration;
% BP-18 T1 force;
% BP-8L	Head cg linear acceleration;
% BP-1 Head resultant acceleration;
% BP-2 Head rotation (ARS);
% BP-3 Head rotation (ARS);
% BP-4 Head rotation (ARS);
% BP-5 T1 compensated load;
% BP-7L	C7/T1 moment;
% BP-9L Roof Force;
% BP-65 T1 linear velocity;
%
% INPUTS:
% filename: full path (string) of filename (just drag and drop the filename
%     into the workspace.
% minrow: 1-based index of the first row of the data (default 9).
% maxrow: 1-based index of the last row of the data (default 21052).
%
% OUTPUTS:
% dat: data output

if nargin<2
    minrow = 9;
    maxrow = 21052;
end
if nargin<3
    maxrow = 21052;
end

m = csvread(filename,minrow-1,0,[minrow-1 0 maxrow-1 11]);

dat.t.x = m(:,1);
dat.t.unit = 's';
dat.t1Az.x = m(:,2);
dat.t1Az.unit = 'g''s';
dat.t1F.x = m(:,3);
dat.t1F.unit = 'N';
dat.headAz.x = m(:,4);
dat.headAz.unit = 'g''s';
dat.headResA.x = m(:,5);
dat.headResA.unit = 'g''s';
dat.headRotY.x = m(:,6);
dat.headRotY.unit = 'deg';
dat.headRotX.x = m(:,7);
dat.headRotX.unit = 'deg';
dat.headRotZ.x = m(:,8);
dat.headRotZ.unit = 'deg';
dat.t1F.x = m(:,9);
dat.t1F.unit = 'N';
dat.c7t1MomY.x = m(:,10);
dat.c7t1MomY.unit = 'Nm';
dat.roofFz.x = m(:,11);
dat.roofFz.unit = 'N';
dat.t1Vz.x = m(:,12);
dat.t1Vz.unit = 'm/s';