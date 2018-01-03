function [newim] = geotransform(im, T)
    % sichergehen dass das bild double ist
    if isa(im,'uint8')
        im = double(im); 
    end
    % rot, gr�n, blau Kan�le seperat transformieren
    im = im/255;  
    [r] = transformImage(im(:,:,1), T);
    [g] = transformImage(im(:,:,2), T);
    [b] = transformImage(im(:,:,3), T);

    newim = repmat(uint8(0),[size(r),3]);
    newim(:,:,1) = uint8(round(r*255));
    newim(:,:,2) = uint8(round(g*255));
    newim(:,:,3) = uint8(round(b*255));
end

function [newim] = transformImage(im, T)
    [rows, cols] = size(im);
    Tinv = inv(T);

    % Output-Image erzeugen
    newim = zeros(rows,cols);
    % Alle m�glichen xy Koordinaten
    [xi,yi] = meshgrid(1:cols,1:rows);  

    % Transform xy Koordinaten 
    sxy = homotrans(Tinv, [xi(:)'; yi(:)'; ones(1,cols*rows)]);
    xi = reshape(sxy(1,:),rows,cols);
    yi = reshape(sxy(2,:),rows,cols);
    % Interpolieren
    newim = interp2(double(im),xi,yi); 
end

function t = homotrans(T, M)
    [dim,npts] = size(M);
    % Transformieren
    t = T*M;  
    % Normalisieren
    for r = 1:dim-1  
        t(r,:) = t(r,:)./t(end,:);
    end
    t(end,:) = ones(1,npts);
end