function out = xfm3d(x,m,v)
% out = xfm3d(x,m,v);
%
% Brian Goodwin 2014-06-19
%
% Provide 3D coordinates (v=1), vectors (v=0), or tensors (v=0) to 
% transform with a 4x4 transformation matrix, m.
%
% INPUTS:
% x: 3D coordinates (n-by-3).
%
%       "x" can also be vector data or tensor data. Tensor data is expected
%       in the form of n-by-6 or n-by-9, where each row is one tensor. In
%       the case of the n-by-6, each column represents the upper triangle
%       of the tensor:
%
%       [ a11 a12 a13 ]
%       [ ... a22 a23 ]
%       [ ... ... a33 ]
%
%       x = [a11 a12 a13 a22 a23 a33]
%
%       Otherwise, the n-by-9 tensor form of x should be:
%
%       x = [a11 a12 a13 a21 a22 a23 a31 a32 a33];
%
%       If x is a column vector of tensor data, "v" input variable is not
%       required. If v is supplied it is ignored.
%
% m: Transformation matrix (4-by-4). If m is 3-by-3, a rotation or scaling
%       only is implied and the v input is ignored
%
% v: 1 or 0. If coordinates are being transformed this should be a 1. If
%       vector data is being transformed, this should be 0. 
%
%       If tensor data is provided, this input is ignored.
%
%       Technical definition: The 4th column is required to have either a 1
%       or 0 for the transformation to work. 
%
%       If translation is involved, vector data would be  changed in an 
%       unwanted way. Usually, coordinates and their vectors need to be 
%       transformed. The vectors should not be "translated" only rotated 
%       (v=0), whereas the coordinates should be both translated and
%       rotated (v=1).
%
% OUTPUS:
% out: transformed x
%
% Example:
% Vector data is given at certain coordinates.
% vectorData = randn(10,3);
% coordinates = randn(10,3);
% m = makehgtform('translate',[1,3,5],'axisrotate',[4,6,1],pi/8);
% newVectorData = xfm3d(vectorData,m,0);
% newCoordinates = xfm3d(coordinates,m,1);

% % Use for debugging:
% m = makehgtform('axisrotate',rand(1,3),rand*pi);
% x = rand(9,6)*2-1;


[N,M] = size(x);
if M==3
    if size(m,1)==3
        out = x*m';
        return
    end
    
    if ~(v==1||v==0)
        error('"v" must be set to 1 or 0.');
    end
    
    if v
        out = bsxfun(@plus,x*m(1:3,1:3).',m(1:3,4).');
    else
        out = x*m(1:3,1:3).';
    end
    return
else
    m = m(1:3,1:3);
    if M==6
        x = mat2cell(x,N,ones(M,1));
        x = cat(2,x{1},x{2},x{3},x{2},x{4},x{5},x{3},x{5},x{6});
        x = reshape(x.',3,3*N).';
    elseif M==9
        x = reshape(x.',3,3*N).';
    else
        error('x must have either 3, 6, or 9 columns.')
    end
    m1 = sparse(m);
    for k = 1:nextpow2(N)
        m1 = blkdiag(m1,m1);
    end
    m1 = m1(1:N*3,1:N*3);
    out = m1*x*m.';
    out = reshape(out.',9,N).';
    if M ==6
        out = mat2cell(out,N,ones(9,1));
        out = cat(2,out{1},out{2},out{3},out{5},out{6},out{9});
    else
        return
    end
end