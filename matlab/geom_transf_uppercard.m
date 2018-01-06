% 	Transformation von einer perspektivischen Projektion zu einer orthogonalen
%   Parameter:
%       card_second         - grayscale image der oberen Karte
%       card_two            - RGB image der oberen Karte
%   Ausgabe:
%       card_two_corrected  - Korrigierte Perspektive
%   Author: Aleksandar Marinkovic 01634028

function [ card_two_corrected ] = geom_transf_uppercard( card_second, card_two )
    
    [firstcorner, secondcorner, thirdcorner, fourthcorner] = cornerDetection(card_second);
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