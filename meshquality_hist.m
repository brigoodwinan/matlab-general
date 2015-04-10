function q = meshquality_hist(v,e,optional)
% q = meshquality_hist(v,e)
%
% Brian Goodwin 2014-07-14
%
% Constructs a histogram of the mesh quality.
%
% This requires Iso2Mesh toolbox to run.
%
% ---------------------------------
% INPUTS
% v: m x 3 points in space
% e: n x 4 tetrahedron connections
% optional: (optional) Title of Histogram (string)
%
% OUPUT:
% q: (optional) mesh quality for each element (n-by-1)
n = size(e,1);
x = linspace(0,1.2,ceil(n./100));

q = meshquality_bdg(v,e);

N = hist(q,x);

figure
bar(x,N,'k')
xlim([0,1.1])

if nargin>2
    title(optional)
else
    title('Mesh Quality (Joe-Liu) Histogram')
end