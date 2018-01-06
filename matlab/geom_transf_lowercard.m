function [ card_one_corrected ] = geom_transf_lowercard( card_first, card_one )
%GEOM_TRANSF_CARD - transforms the lower card from perspective projection to
%orthographic projection
%   Author: Miran Jank, 1526438
%   Input: lower card without perspective correction
%   Output: lower card transformed

%get bounding box of binary images
boundingbox     = regionprops(card_first, 'BoundingBox');
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

%---- Get distance of all relevant edges ----%

distOL = round(pdist([firstcorner;secondcorner],'euclidean'));
distLU = round(pdist([secondcorner;fourthcorner],'euclidean'));
distUR = round(pdist([fourthcorner;thirdcorner],'euclidean'));
distRO = round(pdist([thirdcorner;firstcorner],'euclidean'));

distarray = [distOL,distLU,distUR,distRO];


%---- Search for the shortestpath ,secondshortestpath and longestpath ----%
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

%---- Corner creation and allocation ----%
%Create new corner
newcorner = [0 0];

%Calculate coordinates of the new corner
if(longestpath == distOL)
    if(shortestpath == distRO || secondshortestpath == distRO)
        %left(secondcorner) is to be changed
        
        newcorner = firstcorner - secondcorner;
        betragnewcorner = norm(newcorner);
        einheitsvektor = newcorner/betragnewcorner;
        einheitsvektor = einheitsvektor * (longestpath - shortestpath);
        newcorner = secondcorner + einheitsvektor;
        
        secondcorner = newcorner;
    elseif(shortestpath == distLU || secondshortestpath == distLU)
        %up(firstcorner)
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
        %right(thirdcorner)
        %270° SEMIWORKS - verzerrung, da gedreht
        newcorner = firstcorner - thirdcorner;
        betragnewcorner = norm(newcorner);
        einheitsvektor = newcorner/betragnewcorner;
        einheitsvektor = einheitsvektor * (longestpath - shortestpath);
        newcorner = thirdcorner + einheitsvektor;
        
        thirdcorner = newcorner;
    elseif(shortestpath == distUR || secondshortestpath == distUR)
        %up(firstcorner)
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
        %down(fourthcorner)
        %
        newcorner = secondcorner - fourthcorner;
        betragnewcorner = norm(newcorner);
        einheitsvektor = newcorner/betragnewcorner;
        einheitsvektor = einheitsvektor / (longestpath - shortestpath);
        newcorner =  fourthcorner + einheitsvektor;
        
        fourthcorner = newcorner;
    elseif(shortestpath == distUR || secondshortestpath == distUR)
        %left(secondcorner)
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
        %down(fourthcorner)
        %0° WORKS
        newcorner = thirdcorner - fourthcorner;
        betragnewcorner = norm(newcorner);
        einheitsvektor = newcorner/betragnewcorner;
        einheitsvektor = einheitsvektor * (longestpath - shortestpath);
        newcorner = fourthcorner + einheitsvektor;
        
        fourthcorner = newcorner;
    elseif(shortestpath == distLU || secondshortestpath == distLU)
        %right(thirdcorner)
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

r = [corners(1,1) corners(2,1) corners(3,1) corners(4,1)]';
c = [corners(1,2) corners(2,2) corners(3,2) corners(4,2)]';
% Verhältnis zwischen der linken und rechten Seite
links = [firstcorner; secondcorner];
rechts = [thirdcorner; fourthcorner];
d_l = pdist(links,'euclidean');
d_r = pdist(rechts,'euclidean');

% Kartenverhältnis 5:8 normal - 5:4 bei halber Karte
base = [0 0; 0 4; 5 0; 5 4*(d_r/d_l)]*150;
% Tansformation-Matrix 
movPts = [c r];
fixPts = base;
tform = getTransformationMatrix(movPts',fixPts');

% In double umwandeln
card_one = double(card_one);     
card_one = card_one/255;  

% RGB-Kanäle einzeln transformieren
[r] = geotransform(card_one(:,:,1), tform);
[g] = geotransform(card_one(:,:,2), tform);
[b] = geotransform(card_one(:,:,3), tform);

% Output erzeugen und Kanäle zusammenlegen
card_one_corrected = repmat(uint8(0),[size(r),3]);
card_one_corrected(:,:,1) = uint8(round(r*255));
card_one_corrected(:,:,2) = uint8(round(g*255));
card_one_corrected(:,:,3) = uint8(round(b*255));

%---- Final result ----%
%figure;
%imshow(card_one_corrected);
end

