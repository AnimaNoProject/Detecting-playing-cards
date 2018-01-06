%change the perspective to orthogonal projection
function [orthogonalpersp_card] = perspectiveCorrection(img, firstcorner, secondcorner, thirdcorner, fourthcorner)
    corners     = [firstcorner;secondcorner;thirdcorner;fourthcorner];
    r           = [corners(1,1) corners(2,1) corners(3,1) corners(4,1)]';
    c           = [corners(1,2) corners(2,2) corners(3,2) corners(4,2)]';
    topLeft     = [firstcorner; secondcorner];
    topRight    = [firstcorner; thirdcorner];
    dleft = pdist(topLeft,'euclidean');
    dright = pdist(topRight,'euclidean');
    % Kartenverhältnis 5:8
    if(dleft < dright)
        base = [5 0; 0 0; 5 8; 0 8]*150;
    else
        base = [0 0; 0 8; 5 0; 5 8]*150;  
    end
    %%%%%%%%%%%%%%%%%%% Tansformation-Matrix %%%%%%%%%%%%%%%%%%%
    movPts  = [c r];
    fixPts  = base;
    tform   = getTform(movPts',fixPts');

    img=double(img);
    img=img/255;
    % RGB-Kanäle einzeln transformieren
    [r] = geotransform(img(:,:,1), tform);
    [g] = geotransform(img(:,:,2), tform);
    [b] = geotransform(img(:,:,3), tform);

    % Output erzeugen und Kanäle zusammenlegen
    orthogonalpersp_card = repmat(uint8(0),[size(r),3]);
    orthogonalpersp_card(:,:,1) = uint8(round(r*255));
    orthogonalpersp_card(:,:,2) = uint8(round(g*255));
    orthogonalpersp_card(:,:,3) = uint8(round(b*255));
end