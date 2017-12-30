function [ rotated_Card ] = rotateCard( card )
%ROTATECARD Summary of this function goes here
%   Detailed explanation goes here
%   Jan Michael Lajarno

card_bw = imbinarize(rgb2gray(card), 0.47);

boundingbox     = regionprops(card_bw, 'BoundingBox');
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
    value = card_bw(top, x);
    if(value == 1)
        firstcorner = [top, x];
        break;
    end
end
%get second corner from top left to bottom left
for y = top : bottom
    value = card_bw(y, left);
    if(value == 1)
        secondcorner = [y, left];
        break;
    end
end
%get third corner top right to bottom right
for y = top : bottom
    value = card_bw(y, right);
    if(value == 1)
        thirdcorner = [y, right];
        break;
    end
end
%get fourth corner from bottom left to bottom right
for x = left : right
    value = card_bw(bottom, x);
    if(value == 1)
        fourthcorner = [bottom, x];
        break;
    end
end
corners = [firstcorner;secondcorner;thirdcorner;fourthcorner];


%%%%%%%%%%%%%%%%rotate first card%%%%%%%%%%%%%%%%%
%get nearest edge to firstcorner
length1 = norm(firstcorner - secondcorner);
length2 = norm(firstcorner - thirdcorner);
length3 = norm(firstcorner - fourthcorner);
lenghts = [length1 length2 length3];
[minlength, indexminlength] = min(lenghts);
nearestcorner = corners(indexminlength + 1, :);
%display firstedge and nearest edge

% determine edge for rotating the picture
edgetoratewith      = (nearestcorner - firstcorner);
normedgerotatewith  = edgetoratewith / norm(edgetoratewith);
normedgeinxdirection = [1 0];
%determine angle rotate around
angletorotate = rad2deg(acos(dot(normedgerotatewith, normedgeinxdirection)));
rotated_Card = imrotate(card, 90-angletorotate);

end

