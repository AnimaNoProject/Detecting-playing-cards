% 	Transformation von einer perspektivischen Projektion zu einer orthogonalen
%   Parameter:
%       card_second         - grayscale image der oberen Karte
%       card_two            - RGB image der oberen Karte
%   Ausgabe:
%       card_two_corrected  - Korrigierte Perspektive
%   Author: Aleksandar Marinkovic 01634028

function [ card_two_corrected ] = geom_transf_uppercard( card_second, card_two )
    %%%%%%%%find corner%%%%%%%%%%%%%
    % get bounding box of binary images
    boundingbox     = regionprops(card_second, 'BoundingBox');
    % figure;
    % imshow(card_two)
    % hold on
    % rectangle('Position', [73.5 499.5 1113 1088],	'EdgeColor','r', 'LineWidth', 2)
    boxproperties   = boundingbox.BoundingBox;
    left            = round(boxproperties(1));
    top             = round(boxproperties(2));
    width           = boxproperties(3);
    height          = boxproperties(4);
    right           = round(boxproperties(1) + width) - 1;
    bottom          = round(boxproperties(2) + height) - 1;
    firstcorner     = -1;
    secondcorner    = -1;
    thirdcorner     = -1;
    fourthcorner    = -1;
    %get first corner from top left to top right
    for x = left : right
        value = card_second(top, x);
        if(value == 1)
            firstcorner = [top, x];
            break;
        end
    end
    %get second corner from top left to bottom left
    for y = top : bottom
        value = card_second(y, left);
        if(value == 1)
            secondcorner = [y, left];
            break;
        end
    end
    %get third corner top right to bottom right
    for y = top : bottom
        value = card_second(y, right);
        if(value == 1)
            thirdcorner = [y, right];
            break;
        end
    end
    %get fourth corner from bottom left to bottom right
    for x = left : right
        value = card_second(bottom, x);
        if(value == 1)
            fourthcorner = [bottom, x];
            break;
        end
    end
    corners = [firstcorner;secondcorner;thirdcorner;fourthcorner];

    %%%%%%%%%%%%%%% perspective correction %%%%%%%%%%%%%%% 
    r = [corners(1,1) corners(2,1) corners(3,1) corners(4,1)]';
    c = [corners(1,2) corners(2,2) corners(3,2) corners(4,2)]';

    topLeft = [firstcorner; secondcorner];
    topRight = [firstcorner; thirdcorner];
    dleft = pdist(topLeft,'euclidean');     % Distanz zwischen der oberen und linken Ecke
    dright = pdist(topRight,'euclidean');   % Distanz zwischen der oberen und rechten Ecke
    % Kartenverhältnis 5:8
    % Korrekte Orientierung bestimmen
    if(dleft < dright)
        base = [5 0; 0 0; 5 8; 0 8]*150;
    else
        base = [0 0; 0 8; 5 0; 5 8]*150;
    end

    movPts = [c r];                         % Ecken der Karte
    fixPts = base;                          % hierhin werden die movPts transformiert
    tform = gettform(movPts',fixPts');

    % In double umwandeln
    card_two = double(card_two);     
    card_two = card_two/255;  

    % RGB-Kanäle einzeln transformieren
    [r] = geotransform(card_two(:,:,1), tform);
    [g] = geotransform(card_two(:,:,2), tform);
    [b] = geotransform(card_two(:,:,3), tform);

    % Output erzeugen und Kanäle zusammenlegen
    card_two_corrected = repmat(uint8(0),[size(r),3]);
    card_two_corrected(:,:,1) = uint8(round(r*255));
    card_two_corrected(:,:,2) = uint8(round(g*255));
    card_two_corrected(:,:,3) = uint8(round(b*255));
    % figure;
    % imshow(card_two_corrected);
end