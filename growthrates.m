function out = growthrates(v,e,makehist,optional)
% gr = growthrates(v,e)
% gr = growthrates(v,e,makehist)
% gr = growthrates(v,e,makehist,optionalTitle)
%
% Brian Goodwin 2014-07-12
%
% Calculates the maximum growth rate of tetrahedron elements at each node.
%
% INPUTS:
% v: mesh vertices (n-by-3).
% e: mesh tetrahedral connections (m-by-4).
% makehist: (optional) when set to 1 a histogram is made of the element
%             growth rates. Otherwise it is ignored.
% optionalTitle: (optional) Title of the histogram.
%
% OUTPUTS:
% gr: maximum growthrate of elements around each node have a range of 1:inf
%       (n-by-1)
if size(e,2)>4
    e = e(:,1:4);
end
vol = tetvol(v,e);

n = size(v,1);
m = size(e,1);
i = repmat((1:m).',1,4);
s1 = sparse(e,i,repmat(vol,1,4),n,m);
s2 = sparse(e,i,repmat(1./vol,1,4),n,m);

out = full(max(s1,[],2).*max(s2,[],2));

if nargin>2
    if makehist==1
%         limx = mean(out)+2*std(out);
        limx = max(out);
        x = linspace(1,limx,ceil(n/100));
        N = hist(out,x);
        figure
        bar(x,N,'k');
%         xlim([1,limx*1.1]);
        ylim([0,max(N(1:end-1)).*1.1]);
        if nargin>3
            if ischar(optional)
                title(optional)
            else
                title('Element Growth Histogram')
            end
        end
    end
else
    return
end