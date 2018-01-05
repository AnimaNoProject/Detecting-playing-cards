% 	Perspektivkorrektur eines Bildes 
%   Parameter:
%       im      - Graustufenbild / Channel einzeln transformieren
%       T       - 3x3 Transformationsmatrix
%   Ausgabe:
%       newim   - Transformiertes Bild 
%   Author: Aleksandar Marinkovic 01634028

function newim = geotransform(im, T)
    [rows, cols] = size(im);
    x = (1:cols)';
    y = (1:rows)';
    
    % Alle möglichen xy-Koordinaten
    [xi, yi] = meshgrid(x,y);
    xi_size = length(xi(:));
    
    % mit der Transformationsmatrix multiplizieren 
    imgT = T * [xi(:) yi(:) ones(xi_size, 1)]';
    
    % xy-Koordinaten normalisieren
    xq = imgT(1,:) ./ imgT(3,:);
    yq = imgT(2,:) ./ imgT(3,:);
    
    % Interpolieren & reshapen
    newim = interp2(im, xq, yq);
    newim = reshape(newim, rows, cols);
end