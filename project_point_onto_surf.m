function [pnt,d,fid] = project_point_onto_surf(node,vector,v,f)
% pnt = project_point_onto_surf(node,vector,v,f)
% [pnt,d] = project_point_onto_surf(node,vector,v,f)
% [pnt,d,fid] = project_point_onto_surf(node,vector,v,f)
%
% 2014-02-28 Brian Goodwin
%
% Open MATLABPOOL for faster processing.
%
% Places the node on a provided surface when given a vector, which defines
% the direction of projection for the node. In other words, the first
% surface element that intersects the vector will be the element on which
% the node is placed.
%
% see http://en.wikipedia.org/wiki/Line%E2%80%93plane_intersection for how
% I calculated the intersection point on the line.
%
% INPUTS
% node = nodes in space to be projected onto surface (3-column vector)
% vector = single vector indicating the projection direction of the node.
%        (3-column vector)
% v = surface vertices of the surface the node is to be projected onto.
%        (3-column vector)
% f = surface faces of the surface the node is to be projected onto.
%        1-based indexing (3-column vector)
%
% OUTPUT
% pnt = the projection of the node onto the surface. (3-column vector)
%        returns [inf,inf,inf] if the point cannot be projected along the
%        provided vector.
% d = fraction of vector length to the point lying on surface defined by v
%        and f.
% fid = the face index of the point of intersection.

% % The following is for debugging purposes.
% v = rand(9,3)*-10;
% f = reshape(1:9,3,3);
% 
% node = [-5,-5,-5];
% vector = rand(1,3);
% plotmesh(v,f)
% axis equal
% hold on
% plot3(node(1),node(2),node(3),'.k','markersize',30)
% quiver3(node(1),node(2),node(3),vector(1),vector(2),vector(3),'k')
% hold off
% %

[f1,f2] = size(vector);
if f1==3 && f2~=3
    vector = vector';
end
[f1,f2] = size(node);
if f1==3 && f2~=3
    node = node';
end

[f1,f2] = size(v);
if f1==3 && f2~=3
    v = v';
end
[f1,f2] = size(f);
if f1==3 && f2~=3
    f = f';
end

nlen = size(node,1);

f1 = size(f,1);
n = f1;
N = n*3;
P = reshape(v(f,:)',N*3,1);
P = reshape(P,N,3);

P(:,2:3) = [P(:,2)-P(:,1),P(:,3)-P(:,1)];

i = repmat(1:N,1,3);
j = reshape(repmat([1:3:N,2:3:N,3:3:N],3,1),1,N*3);

P23 = P(:,2:3);
P1 = P(:,1);
d = cell(nlen,1);
pnt = cell(nlen,1);
fid = cell(nlen,1);
tmpv = mat2cell(vector,ones(nlen,1),3);
tmpn = mat2cell(node,ones(nlen,1),3);

if isPoolOpen
    parfor k = 1:nlen
        l1 = repmat(-tmpv{k}',n,1);
        l2 = repmat(tmpn{k}',n,1);
        
        A = sparse(i,j,cat(2,l1,P23),N,N);
        
        tuv = A\(l2-P1);
        tuv = reshape(tuv,3,n)';
        fid{k} = (tuv(:,1)>=0 & tuv(:,2)>=0 & tuv(:,2)<=1 & tuv(:,3)>=0 & tuv(:,3)<=1 & tuv(:,2)+tuv(:,3)<=1);
        tuv = tuv(fid{k},:);
        if ~isempty(tuv)
            [d{k},tmpid] = min(tuv(:,1));
            fid{k} = find(fid{k});
            fid{k} = fid{k}(tmpid);
            pnt{k} = d{k}.*tmpv{k}+tmpn{k};
        else
            d{k} = inf;
            pnt{k} = [inf inf inf];
            fid{k} = nan;
        end
    end
    d = cell2mat(d);
    pnt = cell2mat(pnt);
    fid = cell2mat(fid);
    return
else
    warning('If MATLABPOOL is not open, it is suggested that you abort the function and open it.')
    for k = 1:nlen
        l1 = repmat(-tmpv{k}',n,1);
        l2 = repmat(tmpn{k}',n,1);
        
        A = sparse(i,j,cat(2,l1,P23),N,N);
        
        tuv = A\(l2-P1);
        tuv = reshape(tuv,3,n)';
        fid{k} = (tuv(:,1)>=0 & tuv(:,2)>=0 & tuv(:,2)<=1 & tuv(:,3)>=0 & tuv(:,3)<=1 & tuv(:,2)+tuv(:,3)<=1);
        tuv = tuv(fid{k},:);
        if ~isempty(tuv)
            [d{k},tmpid] = min(tuv(:,1));
            fid{k} = find(fid{k});
            fid{k} = fid{k}(tmpid);
            pnt{k} = d{k}.*tmpv{k}+tmpn{k};
        else
            d{k} = inf;
            pnt{k} = [inf inf inf];
            fid{k} = nan;
        end
    end
	d = cell2mat(d);
	pnt = cell2mat(pnt);
    fid = cell2mat(fid);
	return
end
