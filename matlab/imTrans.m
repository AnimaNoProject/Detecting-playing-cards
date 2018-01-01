% IMTRANS - Homogeneous transformation of an image.
%
% Applies a geometric transform to an image
%
%  [newim] = imTrans(im, T);
%
%  Arguments: 
%        im     - The image to be transformed.
%        T      - The 3x3 homogeneous transformation matrix.        
%  Returns:
%        newim  - The transformed image.

function [newim] = imTrans(im, T);
    % sicher gehen dass das bild double ist
    if isa(im,'uint8')
        im = double(im); 
    end

    [rows, cols, chan] = size(im);
    % size festlegen
    sze = max([rows, cols]);

    % rot, grün, blau Kanäle seperat transformieren
    if chan == 3   
        im = im/255;  
        [r] = transformImage(im(:,:,1), T, sze);
        [g] = transformImage(im(:,:,2), T, sze);
        [b] = transformImage(im(:,:,3), T, sze);

        newim = repmat(uint8(0),[size(r),3]);
        newim(:,:,1) = uint8(round(r*255));
        newim(:,:,2) = uint8(round(g*255));
        newim(:,:,3) = uint8(round(b*255));
    else
        % Ansonsten Graustufenbild transformieren
        [newim] = transformImage(im, T, sze);
    end
end

function [newim] = transformImage(im, T, sze);
    [rows, cols] = size(im);
    region = [1 rows 1 cols];

    % Grenzen des Output-Images
    B = bounds(T,region);
    nrows = round(B(2) - B(1));
    ncols = round(B(4) - B(3));

    % Überprüfung auf neu Skalierung
    s = sze/max(nrows,ncols);

    % Scaling matrix
    S = [s 0 0        
         0 s 0
         0 0 1];

    T = S*T;
    Tinv = inv(T);

    % Grenzen des neu skalierten Bildes
    B = bounds(T,region);
    nrows = round(B(2) - B(1));
    ncols = round(B(4) - B(3));

    % Output-Image mit den neuen Grenzen erzeugen
    newim = zeros(nrows,ncols);
    % Alle möglichen xy Koordinaten
    [xi,yi] = meshgrid(1:ncols,1:nrows);  

    % Transform xy Koordinaten 
    sxy = homoTrans(Tinv, [xi(:)'+B(3); yi(:)'+B(1); ones(1,ncols*nrows)]);
    xi = reshape(sxy(1,:),nrows,ncols);
    yi = reshape(sxy(2,:),nrows,ncols);
    [x,y] = meshgrid(1:cols,1:rows);
    % Interpolieren
    newim = interp2(x,y,double(im),xi,yi); 
end

% Transformiert und gibt die Grenzen des Bildes zurück
% in der Form [minrow maxrow mincol maxcol]
function B = bounds(T, R)
    % homogene Koordinaten der Ecken
    P = [R(3) R(4) R(4) R(3)      
         R(1) R(1) R(2) R(2)
          1    1    1    1   ];

    PT = homoTrans(T,P); 
    B = [min(PT(2,:)) max(PT(2,:)) min(PT(1,:)) max(PT(1,:))];
    %      minrow          maxrow      mincol       maxcol  
end




