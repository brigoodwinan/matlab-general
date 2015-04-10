function [v,e] = remove_short_tracts(tractsv,tractse,th)
% [v,e] = remove_short_tracts(tractsv,tractse,th)
%
% Brian Goodwin, 2014-06-24
%
% Given a tract length threshold, lines having lengths less than the 
% threshold are removed.
%
% INPUTS:
% tractsv: vertices of tracts (lines) (n-by-3)
%
% tractse: edges of tracts (N-by-3)
%
% th: threshold value
%
% OUTPUTS:
% v: pruned vertices of tracts
% 
% e: pruned edges of tracts
%
% NOTE: 
% If you are getting errors, it is likely you need to remove isolated nodes
% from the edge field using "removeisolatednode()" from the Iso2Mesh
% toolbox.

warning('Requires the Iso2Mesh toolbox.')

[L,~,data] = line_lengths(tractsv,tractse);
tmp = find(L'<th); % we are going to delete places where L is less than 50mm
tmpl = true(size(tractse,1),1);
for k = tmp
    tmpl(k==data) = false;
end
tractse = tractse(tmpl,:);
[v,e] = removeisolatednode(tractsv,tractse);
return