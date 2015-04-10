function [imgo,xfmo] = trimlatvol3d(img,xfm)
% [imgo,xfmo] = trimlatvol3d(img,xfm)
% [imgo,xfmo] = trimlatvol3d(img)
% imgo = trimlatvol3d(img)
%
% 2014-01-15, Brian Goodwin
%
% Trims a latvol with data. The latvol is trimmed according to zero valued
% data. This clips the grid of a latvol so that it contains the minimum
% number of cells while still retaining all data.
%
% e.g. 2D example of img:
%
% 0 0 0 0 0 0
% 0 0 1 0 0 0   cliplatvol3d    0 1 0
% 0 2 3 4 0 0 ----------------> 2 3 4
% 0 0 5 0 0 0                   0 5 0
% 0 0 0 0 0 0
% 0 0 0 0 0 0
% 
% INPUTS:
% xfm:   Transformation matrix similar to that which would be obtained from
%         BrainStorm and would be applied to the latvol of the 3D image.
%         xfm must have the form:
%
%                | a11 a12 a13 a14 |
%                | a21 a22 a23 a24 |
%                | a31 a32 a33 a34 |
%                |  0   0   0   1  |
%
%         where a14, a24, a34, are translational.
%
% img:   a NxMxP(xQ) image volume of data. This will be used to "trim" the
%         volume. The volume will be trimmed to the minimum possible latvol
%         dimensions while still retaining all non-zero data. The data
%         would approrpiately apply to a grid generated using ndgrid().
%
% OUTPUTS:
% xfmo:  The new transformation matrix for the latvol after the trimming.
%
% imgo:  The output volumetric image that has been trimmed.

tmp = logical(sum(logical(img),4));
sz = size(img);
[ndx,ndy,ndz] = ndgrid(1:sz(1),1:sz(2),1:sz(3));

ndx = ndx(tmp);
ndy = ndy(tmp);
ndz = ndz(tmp);

xmin = min(ndx);
xmax = max(ndx);
ymin = min(ndy);
ymax = max(ndy);
zmin = min(ndz);
zmax = max(ndz);

imgo = img(xmin:xmax,ymin:ymax,zmin:zmax,:);

if nargout>1
    xfmo = makehgtform('translate',[xmin,ymin,zmin]);
    if nargin>1
        xfmo = xfm*xfmo;
    end
end
end