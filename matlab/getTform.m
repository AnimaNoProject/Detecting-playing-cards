% HOMOGRAPHY2D - computes 2D homography
%
% Usage:   H = homography2d(x1, x2)
%          H = homography2d(x)
%
% Arguments:
%          mov  - 3xN set of homogeneous points
%          fix  - 3xN set of homogeneous points such that x1<->x2
%         
% Returns:
%          H - the 3x3 homography such that x2 = H*x1
%
% This code follows the normalised direct linear transformation 
% algorithm given by Hartley and Zisserman "Multiple View Geometry in
% Computer Vision" p92.

function H = gettform(mov,fix)
    % Punkte normalisieren
    [mov, T1] = normalise2dpts(mov);
    [fix, T2] = normalise2dpts(fix);
  
    Npts = length(mov);
    A = zeros(3*Npts,9);
    
    for n = 1:Npts
        X = mov(:,n)';
        x = fix(1,n); 
        y = fix(2,n); 
        w = fix(3,n);
        A(3*n-2,:) = [0 0 0  -w*X     y*X];
        A(3*n-1,:) = [w*X    0 0 0   -x*X];
    	A(3*n  ,:) = [-y*X    x*X   0 0 0];
    end
    
    [U,D,V] = svd(A,0); % 'Economy' decomposition for speed
    
    % 3x3 Matrix 
    H = reshape(V(:,9),3,3)';
    
    % Denormalise
    H = T2\H*T1;
end
    