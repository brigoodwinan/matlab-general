function r = bary2cart(lambda,v,f)
% r = bary2cart(lambda,v,f)
%
% 2014-09-16 Brian Goodwin
%
% Requires the iso2mesh toolbox for the "surfnorm()" function.
%
% Converts Barycentric coordinates to cartesian coordinates.
%
% INPUTS:
% lambda: barycentric points (n-by-2)
% v: vertices of triangles (m-by-3)
% f: triangle faces (n-by-3)
%
% OUTPUTS:
% r: cartesian coordinates of corresponding barycentric points.

snorms = surfnorm(v,f);
vcent = calculate_element_center(v,f);

n = size(lambda,1);
if n>1
    snorms = mat2cell(snorms,ones(n,1),3);
    vcent = mat2cell(vcent,ones(n,1),3);
    f = mat2cell(f,ones(n,1),3);
    lambda = mat2cell(lambda,ones(n,1),2);
    r = cell(n,1);
    
    if isPoolOpen
        parfor k = 1:n
            r{k} = zeros(1,3);
            m = makehgtform('axisrotate',sum(cat(1,[0 0 1],snorms{k})),pi,'translate',-vcent{k});
            tri = xfm3d(v(f{k},:),m,1);
            tri = tri(:,1:2);
            T = bsxfun(@minus,tri(1:2,:),tri(3,:)).';
            r{k}(1:2) = lambda{k}*T.'+tri(3,:);
            r{k} = xfm3d(r{k},inv(m),1);
        end
        r = cell2mat(r);
        return
    else
        warning('If MATLABPOOL is not open, it is suggested that you abort the function and open it for large point fields.')
        for k = 1:n
            r{k} = zeros(1,3);
            m = makehgtform('axisrotate',sum(cat(1,[0 0 1],snorms{k})),pi,'translate',-vcent{k});
            tri = xfm3d(v(f{k},:),m,1);
            tri = tri(:,1:2);
            T = bsxfun(@minus,tri(1:2,:),tri(3,:)).';
            r{k}(1:2) = lambda{k}*T.'+tri(3,:);
            r{k} = xfm3d(r{k},inv(m),1);
        end
        r = cell2mat(r);
        return
    end
else
    r = zeros(1,3);
    m = makehgtform('axisrotate',sum(cat(1,[0 0 1],snorms)),pi,'translate',-vcent);
    tri = xfm3d(v(f,:),m,1);
    tri = tri(:,1:2);
    T = bsxfun(@minus,tri(1:2,:),tri(3,:)).';
    r(1:2) = lambda*T.'+tri(3,:);
    r = xfm3d(r,inv(m),1);
end