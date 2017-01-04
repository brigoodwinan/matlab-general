function out = outputMaximum(in)
% out = outputMaximum(in)
%
% Brian Goodwin 2017-01-03
%
% Experiment to see if a recursive function can be made to output the
% maxium value in a vector.

% if size(in,1) > 1 || size(in,2) > 1
%     in = in(:);
% end
n = numel(in);
d = fix(n/2);
if d==0
    out = in(1);
elseif d<3
    if in(1)>=in(d)
        out = in(1);
    else
        out = in(d);
    end
    return
else
    s1 = outputMaximum(in(1:d));
    s2 = outputMaximum(in(d+1:n));
    if s1>=s2
        out = s1;
    else
        out = s2;
    end
end