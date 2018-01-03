function  [newim] = geotransform2(im, T)
    
    [rows, cols] = size(im);
    x = (1:cols)';
    y = (1:rows)';
    
    % Alle möglichen xy-Koordinaten
    [xi, yi] = meshgrid(x,y);
    xi_size = length(xi(:));
    
    % mit der inversen Transformationsmatrix multiplizieren 
    % \ statt multiplizieren, wird von matlab empfohlen läuft schneller
    imgT = T \ [xi(:) yi(:) ones(xi_size, 1)]';
    
    % xy-Koordinaten normalisieren
    x = imgT(1,:) ./ imgT(3,:);
    y = imgT(2,:) ./ imgT(3,:);
    
    % Interpolieren 
    newim = interp2(im, x, y);
    newim = reshape(newim, rows, cols);
end