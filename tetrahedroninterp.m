function interpdata = tetrahedroninterp(v,c,data,node)
% function interpdata = tetrahedroninterp(v,c,data,node)
% Brian Goodwin
% 2014-04-14
%
% Linearly interpolates data given a tetraheral mesh. If nodes are given
% that are outside the mesh, NaNs are returned.
%
% INPUTS:
% v: vertices of mesh (nx3)
% c: "cells" or tetrahetra of mesh (mx4)
% data: data on vertices (v) in mesh (nx1)
% node: vertices to interpolate data onto
% 
% OUTPUTS:
% interpdata: interopolated data
%
% See http://en.wikipedia.org/wiki/Barycentric_coordinate_system

% % The following is for debugging purposes.
% clear
% clc
% v = [0 0 0;1 0 0;0 1 0; 0 0 1; 1 1 1];
% c = [1 2 3 4;2,3,4,5];
% node = rand(2,3);
% data = ceil(rand(5,1)*10);
% 
% plot3(v(:,1),v(:,2),v(:,3),'.k','markersize',20)
% hold on
% plot3(node(:,1),node(:,2),node(:,3),'.r','markersize',30)
% axis equal
% hold off

n = size(c,1);
N = 3*n;
m = size(node,1);

% Make T matrix in a single row for each element
T = [
    reshape(v(c(:,1:3),1),n,3)-repmat(v(c(:,4),1),1,3),...
    reshape(v(c(:,1:3),2),n,3)-repmat(v(c(:,4),2),1,3),...
    reshape(v(c(:,1:3),3),n,3)-repmat(v(c(:,4),3),1,3)
    ];

interpdata = zeros(m,1);

% Limit the size of matrix
if (N*m)>20e6
    packet = floor(20e6/N);
    numpacket = floor(m/packet);
    finpacket = rem(m,packet);
    
    for k = 1:numpacket
        interpdata(((k-1)*packet+1):(k*packet)) = subfun(v,c,data,node(((k-1)*packet+1):(k*packet),:),n,N,packet,T);
    end
    interpdata((numpacket*packet+1):(numpacket*packet+finpacket)) = subfun(v,c,data,node((numpacket*packet+1):(numpacket*packet+finpacket),:),n,N,finpacket,T);
    return
else
    interpdata = subfun(v,c,data,node,n,N,m,T);
    return
end
    
end

function interpdata = subfun(v,c,data,node,n,N,m,T)

% Making location indices
i = reshape(repmat((1:n*3),3,1),1,9*n);
j = reshape(repmat((1:3:n*3),3,1),1,N);
j = reshape([j;j+1;j+2],1,9*n);

T = sparse(i,j,T',N,N,9*n);

r = repmat(node',n,1)-repmat(reshape(v(c(:,4),:)',N,1),1,m);

lambda = T\r;

% need to calculated lambda_4 and then find which element the node exists
% in for interpolation

% lambda1 = lambda(1:3:N,:); lambda2 = lambda(2:3:N,:); lambda3 = lambda(3:3:N,:); 
lambda4 = 1-lambda(1:3:N,:)-lambda(2:3:N,:)-lambda(3:3:N,:);
% clearvars lambda

ind = (lambda(1:3:N,:)>0)&(lambda(2:3:N,:)>0)&(lambda(3:3:N,:)>0)&(lambda4>0);%(1-lambda(1:3:N,:)-lambda(2:3:N,:)-lambda(3:3:N,:))>0);

extrap = find(~any(ind));

if ~isempty(extrap)
    ind(1,extrap) = 1;
end

[I,J] = find(ind);
Ibary = (I-1)*3+1;

% index = J.*N-(N-Ibary) ==> N*(J-1)+I
tmp = N.*(J-1);
bary = cat(2,lambda(tmp+Ibary),lambda(tmp+Ibary+1),lambda(tmp+Ibary+2),lambda4(n.*(J-1)+I));

interpdata = sum(bary.*data(c(I,:)),2);
if ~isempty(extrap)
    interpdata(extrap) = NaN;
end
return
end
