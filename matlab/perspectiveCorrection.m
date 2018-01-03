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
        base = [5 0; 0 0; 5 8; 0 8];
    else
        base = [0 0; 0 8; 5 0; 5 8];  
    end
    %%%%%%%%%%%%%%%%%%% Tansformation-Matrix %%%%%%%%%%%%%%%%%%%
    movPts  = [c r];
    fixPts  = base;
    movPtsH = makehomogeneous(movPts');
    fixPtsH = makehomogeneous(fixPts');
    tform   = gettform(movPtsH,fixPtsH);

    orthogonalpersp_card = geotransform(img, tform);
end