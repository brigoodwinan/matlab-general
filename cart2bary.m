function lambda = cart2bary(r,v,f)
% lambda = cart2bary(r,v,f)
%
% 2014-09-16 Brian Goodwin
%
% Converts cartesian coordinates (even 3D) to Barycentric coordinates.
%
% INPUTS:
% r: point that is within or roughly within a triangle (n-by-3)
% v: vertices of triangles (m-by-3)
% f: triangle faces (n-by-3)
%
% OUTPUTS:
% lambda: barycentric coordinates of corresponding triangle.

snorms = surfnorm(v,f);
vcent = calculate_element_center(v,f);

n = size(r,1);
if n>1
    snorms = mat2cell(snorms,ones(n,1),3);
    r = mat2cell(r,ones(n,1),3);
    vcent = mat2cell(vcent,ones(n,1),3);
    f = mat2cell(f,ones(n,1),3);
    lambda = cell(n,1);
    
    if isPoolOpen
        parfor k = 1:n
            m = makehgtform('axisrotate',sum(cat(1,[0 0 1],snorms{k})),pi,'translate',-vcent{k});
            tmpr = xfm3d(r{k},m,1);
            tri = xfm3d(v(f{k},:),m,1);
            tmpr = tmpr(1:2);
            tri = tri(:,1:2);
            T = bsxfun(@minus,tri(1:2,:),tri(3,:)).';
            lambda{k} = (T\(tmpr-tri(3,:)).').';
        end
        lambda = cell2mat(lambda);
        return
    else
        warning('If MATLABPOOL is not open, it is suggested that you abort the function and open it for large point fields.')
        for k = 1:n
            m = makehgtform('axisrotate',sum(cat(1,[0 0 1],snorms{k})),pi,'translate',-vcent{k});
            tmpr = xfm3d(r{k},m,1);
            tri = xfm3d(v(f{k},:),m,1);
            tmpr = tmpr(1:2);
            tri = tri(:,1:2);
            T = bsxfun(@minus,tri(1:2,:),tri(3,:)).';
            lambda{k} = (T\(tmpr-tri(3,:)).').';
        end
        lambda = cell2mat(lambda);
        return
    end
    
else
    m = makehgtform('axisrotate',sum(cat(1,[0 0 1],snorms)),pi,'translate',-vcent);
    r = xfm3d(r,m,1);
    tri = xfm3d(v(f,:),m,1);
    r = r(1:2);
    tri = tri(:,1:2);
    T = bsxfun(@minus,tri(1:2,:),tri(3,:)).';
    lambda = (T\(r-tri(3,:)).').';
    return
end