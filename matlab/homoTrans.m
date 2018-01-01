% HOMOTRANS - homogeneous transformation of points
%
% Function to perform a transformation on homogeneous points/lines
% The resulting points are normalised to have a homogeneous scale of 1
%
% Usage:
%           t = homoTrans(P,v);
%
% Arguments:
%           tform  - 3 x 3 or 4 x 4 transformation matrix
%           v  - 3 x n or 4 x n matrix of points/lines

function t = homoTrans(tform,v);
   [dim,npts] = size(v);
    % Transformieren
    t = tform*v;  
    % Normalisieren
    for r = 1:dim-1     
	t(r,:) = t(r,:)./t(end,:);
    end
    t(end,:) = ones(1,npts);
end