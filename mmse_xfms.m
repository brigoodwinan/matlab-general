function out = mmse_xfms(m)
% out = mmse_rotmat(m)
%
% Brian Goodwin, 2014-07-03
%
% Sometimes a "mean" transformation needs to be acquired. Just performing a
% mean is hard to justify. This function finds the 4x4 transformation that
% satisfies MMSE criterion with a specific weighting function designed to 
% find the best representation of the population of transformation 
% matrices.
%
% This function uses a "goodness of fit" approach. Each xfm is converted to
% a translation and a quaternion. Each translation and quaternion is 
% weighted with respect to its closeness to the mean (r):
%
% weight = erfcx(r.*3/std(r))
%
% Please see the m-file "debugging_mmse_rotmat.m" to see how this was
% tested.
%
% This finds the rotation matrix that satisfies minimum mean square error
% criterion. Works best for similar transformations.
%
% Requires Optimization toolbox (uses lsqnonlin).
%
% INPUTS:
% m: n-by-1 cell structure of rotation matrices
%
% OUTPUTS:
% out: a single rotation matrix that satisfies mmse

N = length(m);

trans = cell(N,1);
for k = 1:N
    trans{k} = m{k}(1:3,4)';
end

trans = cell2mat(trans);
x0 = mean(trans);
r = sqrt(sum(bsxfun(@minus,trans,x0).^2,2));
weight = erfcx(r.*3./std(r));
weight = weight./max(weight);

% Debugging purposes
disp('translation weights:')
disp(weight)
%

% Need to put in an optimization option that sets the tolerance.

trans = lsqnonlin(@errorfun,x0,min(trans),max(trans),[],trans,weight);

tmp = cell(N,1);
for k = 1:N
    tmp{k} = m{k}(1:3,1:3);
end

q = qGetQ(tmp);
x0 = mean(q);
r = sqrt(sum(bsxfun(@minus,q,x0).^2,2));
weight = erfcx(r.*3./std(r));
weight = weight./max(weight);

% Debugging purposes
disp('quaternion weights:')
disp(weight)
%

x = lsqnonlin(@errorfun,x0,-ones(1,4),ones(1,4),[],q,weight);

x = x./norm(x);

tmp = qGetR(x);
out = cat(2,cat(1,tmp,[0 0 0]),[trans';1]);
end

%% Cost Function
function out = errorfun(x,q,weight)
% out = sqrt(sum(bsxfun(@minus,x(2:4),q(:,2:4)).^2,2))+abs(q(:,1)-x(1));
out = sqrt(sum(bsxfun(@minus,x,q).^2,2)).*weight;
end