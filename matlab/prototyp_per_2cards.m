% Prototype here please %

%1. Karten teilen/ 2 separate bilder erstellen mit je 1 Karte
%2. Geometrisch projezieren / homogenes Bild erhalten
%3. Template matching - resultat erhalten

% Original Image
%input = imread('input/testc2.jpg');
input = imread('input/Datensaetze/Spielsimulation/Spiel 1/Spielzug_1.jpg');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Grayscale image
input_gray = rgb2gray(input);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Binarized Image
binaryInput = imbinarize(input_gray, 0.5);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% connected components
CC = bwconncomp(binaryInput);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Dummy Image
BW2 = zeros(size(binaryInput)); 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Sort biggest Components
numPixels = cellfun(@numel,CC.PixelIdxList);
[biggest, idx] = sort(numPixels,'descend');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Fill the holes in the 2 components
card_first = zeros(size(binaryInput));
card_first(CC.PixelIdxList{idx(1)}) = 1;
filled_first = imfill(card_first, 'holes');

card_second = zeros(size(binaryInput));
card_second(CC.PixelIdxList{idx(2)}) = 1;
filled_second = imfill(card_second, 'holes');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%xxx = sum(filled_first)
%%yyy = sum(filled_second)
%Decide which card is bigger by comparing the pixels
if(sum(filled_first) > sum(filled_second))
    card_first = filled_first;
    card_second = filled_second;
else
    card_first = filled_second;
    card_second = filled_first;
end;
%figure;
%imshow(card_first);
%figure;
%imshow(card_second);
%figure;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Get the RGB card from the Original image by dotmultiplying with the binary
%image
card_one = input;
card_two = input;

card_one(:,:,1) = double(card_one(:,:,1)) .* card_first(:,:);
card_one(:,:,2) = double(card_one(:,:,2)) .* card_first(:,:);
card_one(:,:,3) = double(card_one(:,:,3)) .* card_first(:,:);

card_two(:,:,1) = double(card_two(:,:,1)) .* card_second(:,:);
card_two(:,:,2) = double(card_two(:,:,2)) .* card_second(:,:);
card_two(:,:,3) = double(card_two(:,:,3)) .* card_second(:,:);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Show both cards
%imshowpair(card_one, card_two, 'Montage');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%grayscale of the two single cards
card_one_gray = rgb2gray(card_one);
card_two_gray = rgb2gray(card_two);

%{
%%%%%%%%find corner%%%%%%%%%%%%%
%get bounding box of binary images
boundingbox     = regionprops(card_first, 'BoundingBox');
%figure;
%imshow(card_one)
%hold on
%rectangle('Position', [32.5 247.5 228 263],	'EdgeColor','r', 'LineWidth', 2)
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
    value = card_first(top, x);
    if(value == 1)
        firstcorner = [top, x];
        break;
    end
end
%get second corner from top left to bottom left
for y = top : bottom
    value = card_first(y, left);
    if(value == 1)
        secondcorner = [y, left];
        break;
    end
end
%get third corner top right to bottom right
for y = top : bottom
    value = card_first(y, right);
    if(value == 1)
        thirdcorner = [y, right];
        break;
    end
end
%get fourth corner from bottom left to bottom right
for x = left : right
    value = card_first(bottom, x);
    if(value == 1)
        fourthcorner = [bottom, x];
        break;
    end
end
corners = [firstcorner;secondcorner;thirdcorner;fourthcorner];

%%figure();
%%imshow(card_one_gray);
hold on;
plot(firstcorner(2),firstcorner(1), '*');
plot(secondcorner(2),secondcorner(1), '*');
plot(thirdcorner(2),thirdcorner(1), '*');
plot(fourthcorner(2),fourthcorner(1), '*');
hold off;


%%%%%%%%%%%%%%% perspective correction %%%%%%%%%%%%%%% 
% Auf beide Arten transformieren und nach der größeren Genaugkeit auswählen
%r = [firstcorner(1) secondcorner(1) thirdcorner(1) fourthcorner(1)]';
%c = [firstcorner(2) secondcorner(2) thirdcorner(2) fourthcorner(2)]';
r = [corners(1,1) corners(2,1) corners(3,1) corners(4,1)]';
c = [corners(1,2) corners(2,2) corners(3,2) corners(4,2)]';

topLeft = [firstcorner; secondcorner];
topRight = [firstcorner; thirdcorner];
dleft = pdist(topLeft,'euclidean');
dright = pdist(topRight,'euclidean');
% Kartenverhältnis 5:8
if(dleft < dright)
    base = [5 0; 0 0; 5 8; 0 8];
else
    base = [0 0; 0 8; 5 0; 5 8];  
end

%%%%%%%%%%%%%%%%%%% Tansformation-Matrix %%%%%%%%%%%%%%%%%%%
movPts = [c r];
fixPts = base;
% tform = getTform(movPts, fixPts);

movPtsH = makehomogeneous(movPts');
fixPtsH = makehomogeneous(fixPts');
tform = gettform(movPtsH,fixPtsH);

card_one_corrected = imTrans(card_one, tform);
%%figure;
%%imshow(card_one_corrected);
%}



%%%%%%%%find corner 2. Karte%%%%%%%%%%%%%
%get bounding box of binary images
boundingbox     = regionprops(card_first, 'BoundingBox');
%%chull = regionprops(card_second, 'ConvexHull')
%figure;
%imshow(card_two)
%hold on
%rectangle('Position', [[70.5 53.5 234 200]], 'EdgeColor','r', 'LineWidth', 2)
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
    value = card_first(top, x);
    if(value == 1)
        firstcorner = [top, x];
        break;
    end
end
%get second corner from top left to bottom left
for y = top : bottom
    value = card_first(y, left);
    if(value == 1)
        secondcorner = [y, left];
        break;
    end
end
%get third corner top right to bottom right
for y = top : bottom
    value = card_first(y, right);
    if(value == 1)
        thirdcorner = [y, right];
        break;
    end
end
%get fourth corner from bottom left to bottom right
for x = left : right
    value = card_first(bottom, x);
    if(value == 1)
        fourthcorner = [bottom, x];
        break;
    end
end


%---- Test for all corners ----% 

%figure();
%imshow(card_one_gray);
%hold on;
%plot(10,10,'x');
%plot(30,10,'x');
%plot(10,30,'x');
%plot(firstcorner(2),firstcorner(1), '+');
%plot(secondcorner(2),secondcorner(1), '*');
%plot(thirdcorner(2),thirdcorner(1), 's');
%plot(fourthcorner(2),fourthcorner(1), 'o');
%hold off;


distOL = round(pdist([firstcorner;secondcorner],'euclidean'));
distLU = round(pdist([secondcorner;fourthcorner],'euclidean'));
distUR = round(pdist([fourthcorner;thirdcorner],'euclidean'));
distRO = round(pdist([thirdcorner;firstcorner],'euclidean'));

distarray = [distOL,distLU,distUR,distRO];


%Suche die zwei kürzesten Kanten und die längste Kante
shortestpath = distOL;
secondshortestpath = distRO;
longestpath = distOL;

for i = 1:4
    if(distarray(i) < shortestpath)
        shortestpath = distarray(i);
    end
    if(distarray(i) > longestpath)
        longestpath = distarray(i);
    end
end

TEMP = 50000;
for i = 1:4
    if(distarray(i) == shortestpath)
    elseif((distarray(i) - shortestpath) < TEMP)
        secondshortestpath = distarray(i);
        TEMP = distarray(i) - shortestpath;
    end
end

%Erzeuge neuen Eckpunkt
newcorner = [0 0];

%Berechne die Koordinaten des neuen Punktes
if(longestpath == distOL)
    if(shortestpath == distRO || secondshortestpath == distRO)
        %links(secondcorner) ist das zu lange eck
        
        newcorner = firstcorner - secondcorner;
        betragnewcorner = norm(newcorner);
        einheitsvektor = newcorner/betragnewcorner;
        einheitsvektor = einheitsvektor * (longestpath - shortestpath);
        newcorner = secondcorner + einheitsvektor;
        
        secondcorner = newcorner;
    elseif(shortestpath == distLU || secondshortestpath == distLU)
        %oben(firstcorner) ist das zu lange eck
        %180° WORKS
        newcorner = secondcorner - firstcorner;
        betragnewcorner = norm(newcorner);
        einheitsvektor = newcorner/betragnewcorner;
        einheitsvektor = einheitsvektor * (longestpath - shortestpath);
        newcorner = firstcorner + einheitsvektor;
        
        firstcorner = newcorner;
    end
elseif(longestpath == distRO)
    if(shortestpath == distOL || secondshortestpath == distOL)
        %rechts(thirdcorner) ist das zu lange eck
        %270° SEMIWORKS - verzerrung, da gedreht
        newcorner = firstcorner - thirdcorner;
        betragnewcorner = norm(newcorner);
        einheitsvektor = newcorner/betragnewcorner;
        einheitsvektor = einheitsvektor * (longestpath - shortestpath);
        newcorner = thirdcorner + einheitsvektor;
        
        thirdcorner = newcorner;
    elseif(shortestpath == distUR || secondshortestpath == distUR)
        %oben(firstcorner) ist das zu lange eck
        %
        newcorner = thirdcorner - firstcorner;
        betragnewcorner = norm(newcorner);
        einheitsvektor = newcorner/betragnewcorner;
        einheitsvektor = einheitsvektor * (longestpath - shortestpath);
        newcorner = firstcorner + einheitsvektor;
        
        firstcorner = newcorner;
    end
elseif(longestpath == distLU)
    if(shortestpath == distOL || secondshortestpath == distOL)
        %unten(fourthcorner)ist das zu lange eck
        %
        newcorner = secondcorner - fourthcorner;
        betragnewcorner = norm(newcorner);
        einheitsvektor = newcorner/betragnewcorner;
        einheitsvektor = einheitsvektor * (longestpath - shortestpath);
        newcorner = fourthcorner + einheitsvektor;
        
        fourthcorner = newcorner;
    elseif(shortestpath == distUR || secondshortestpath == distUR)
        %links(secondcorner)ist das zu lange eck
        %90° SEMIWORKS - verzerrung, da gedreht
        newcorner = fourthcorner - secondcorner;
        betragnewcorner = norm(newcorner);
        einheitsvektor = newcorner/betragnewcorner;
        einheitsvektor = einheitsvektor * (longestpath - shortestpath);
        newcorner = secondcorner + einheitsvektor;
        
        secondcorner = newcorner;
    end
elseif(longestpath == distUR)
    if(shortestpath == distRO || secondshortestpath == distRO)
        %unten(fourthcorner) ist das zu lange eck
        %0° WORKS
        newcorner = thirdcorner - fourthcorner;
        betragnewcorner = norm(newcorner);
        einheitsvektor = newcorner/betragnewcorner;
        einheitsvektor = einheitsvektor * (longestpath - shortestpath);
        newcorner = fourthcorner + einheitsvektor;
        
        fourthcorner = newcorner;
    elseif(shortestpath == distLU || secondshortestpath == distLU)
        %rechts(thirdcorner) ist das zu lange eck
        %
        newcorner = fourthcorner - thirdcorner;
        betragnewcorner = norm(newcorner);
        einheitsvektor = newcorner/betragnewcorner;
        einheitsvektor = einheitsvektor * (longestpath - shortestpath);
        newcorner = thirdcorner + einheitsvektor;
        
        thirdcorner = newcorner;
    end
end

%---- Test for all corners including the new one ----% 

%figure();
%imshow(card_one_gray);
%hold on;
%plot(10,10,'x');
%plot(30,10,'o');
%plot(10,30,'s');
%plot(firstcorner(2),firstcorner(1), '+');
%plot(secondcorner(2),secondcorner(1), '*');
%plot(thirdcorner(2),thirdcorner(1), 's');
%plot(fourthcorner(2),fourthcorner(1), 'o');
%plot(newcorner(2),newcorner(1), 'p'); % um alle punkte korrekt zu sehen -> lösche eckenneuzuweisung
%hold off;


corners = [firstcorner;secondcorner;thirdcorner;fourthcorner];

% Auf beide Arten transformieren und nach der größeren Genaugkeit auswählen
r = [corners(1,1) corners(2,1) corners(3,1) corners(4,1)]';
c = [corners(1,2) corners(2,2) corners(3,2) corners(4,2)]';
% Verhältnis zwischen der linken und rechten Seite
links = [firstcorner; secondcorner];
rechts = [thirdcorner; fourthcorner];
d_l = pdist(links,'euclidean');
d_r = pdist(rechts,'euclidean');

% Kartenverhältnis 5:8 normal - 5:4 bei halber Karte
base = [0 0; 0 4; 5 0; 5 4*(d_r/d_l)];
%%%%%%%%%%%%%%%%%%% Tansformation-Matrix %%%%%%%%%%%%%%%%%%%
movPts = [c r];
fixPts = base;

movPtsH = makehomogeneous(movPts');
fixPtsH = makehomogeneous(fixPts');
tform = gettform(movPtsH,fixPtsH);

card_one_corrected = imTrans(card_one, tform);

%figure;
%imshow(card_one_corrected);



