% NORMALISE2DPTS - normalises 2D homogeneous points
%
% Function translates and normalises a set of 2D homogeneous points 
% so that their centroid is at the origin and their mean distance from 
% the origin is sqrt(2).  This process typically improves the
% conditioning of any equations used to solve homographies, fundamental
% matrices etc.
%
% Usage:   [newpts, T] = normalise2dpts(pts)
%
% Argument:
%   pts -  3xN array of 2D homogeneous coordinates
%
% Returns:
%   newpts -  3xN array of transformed 2D homogeneous coordinates.  The
%             scaling parameter is normalised to 1 unless the point is at
%             infinity. 
%   T      -  The 3x3 transformation matrix, newpts = T*pts

function [newpts, T] = normalise2dpts(pts)

    npts = 1:4;
    s = mean(pts(1:2,npts)')';          
    newp(1,npts) = pts(1,npts)-s(1);    % Verschiebe xy um s
    newp(2,npts) = pts(2,npts)-s(2);
    
    dist = hypot(newp(1,npts), newp(2,npts));
    meandist = mean(dist(:));
    
    scale = sqrt(2)/meandist;
    
    T = [scale   0   -scale*s(1)
         0     scale -scale*s(2)
         0       0      1      ];
    
    newpts = T*pts;
end
    
    