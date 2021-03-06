% Prototype here please %

%1. Karten teilen/ 2 separate bilder erstellen mit je 1 Karte
%2. Geometrisch projezieren / homogenes Bild erhalten
%3. Template matching - resultat erhalten

% Original Image
input = imread('input/test_img_per.jpg');
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

%Decide which card is bigger by comparing the pixels
if(sum(filled_first) > sum(filled_second))
    card_first = filled_first;
    card_second = filled_second;
else
    card_first = filled_second;
    card_second = filled_first;
end;
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
imshowpair(card_one, card_two, 'Montage');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%grayscale of the two single cards
card_one_gray = rgb2gray(card_one);
card_two_gray = rgb2gray(card_two);


%%%%%%%%find corner%%%%%%%%%%%%%
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
corners = [firstcorner;secondcorner;thirdcorner;fourthcorner];

figure();
imshow(card_one_gray);
hold on;
plot(firstcorner(2),firstcorner(1), '*');
plot(secondcorner(2),secondcorner(1), '*');
plot(thirdcorner(2),thirdcorner(1), '*');
plot(fourthcorner(2),fourthcorner(1), '*');
hold off;
%%%%%%%%%%%%%%%%rotate first card%%%%%%%%%%%%%%%%%
%get nearest edge to firstcorner
length1 = norm(firstcorner - secondcorner);
length2 = norm(firstcorner - thirdcorner);
length3 = norm(firstcorner - fourthcorner);
lenghts = [length1 length2 length3];
[minlength, indexminlength] = min(lenghts);
nearestcorner = corners(indexminlength + 1, :);
%display firstedge and nearest edge
figure();
imshow(card_one_gray);
hold on;
plot(firstcorner(2),firstcorner(1),'*');
plot(nearestcorner(2),nearestcorner(1), '*');
hold off;
% determine edge for rotating the picture
edgetoratewith      = (nearestcorner - firstcorner);
normedgerotatewith  = edgetoratewith / norm(edgetoratewith);
normedgeinxdirection = [1 0];
%determine angle rotate around
angletorotate = rad2deg(acos(dot(normedgerotatewith, normedgeinxdirection)));
rotated_card_one_gray = imrotate(card_one_gray, 90-angletorotate);
figure();
imshow(rotated_card_one_gray);
%%%%%%%%%%%%rotate the second card%%%%%%%%%%%%%%%%%%%%

%determine edge for rotating the picture 
% input = imread('input/IMG_6660.jpg');
% figure();
% imshow(input);
% %wende canny algorithmus an
% sigma = 0.5;
% inputgrey = double(rgb2gray(input));
% inputcanny = edge(inputgrey, 'Canny', sigma);
% figure();
% imshow(inputcanny);
% %morphologie nutzen damit die kanten besser ausschauen
% se = strel('square',5);
% %se = strel('disk',10);
% inputmorph = imdilate(inputcanny,se);
% %noise reduzieren
% inputfilt = medfilt2(inputmorph);
% %finde ecken
% corners = corner(inputmorph);
% %f�r jeden punkt berechne den winkel
% xsobelfilter = [-1 0 1; -2 0 2; -1 0 1];
% ysobelfilter = [-1 -2 -1; 0 0 0; 1 2 1] ;
% xsobel = imfilter(double(inputfilt), xsobelfilter);
% ysobel = imfilter(double(inputfilt), ysobelfilter);
% phi = rad2deg(atan2(xsobel, ysobel));
% %boundingbox
% boundary = regionprops(inputfilt, 'BoundingBox');
% boundingbox = boundary.BoundingBox;
% hold on;
% imshow(inputmorph);
% rectangle('Position',boundingbox,'EdgeColor','r','LineWidth',2);
% figure;
% %corner template bekommen
% templatecorner         = imread('input/corner_template.png');
% templategreycorner     = double(rgb2gray(templatecorner));
% templatecannycorner   = edge(templategreycorner, 'Canny', sigma);
% imshow(templatecannycorner);
% figure;
% %ecken  3 mal drehen
% templatecannycorner90 = rot90(templatecannycorner);
% templatecannycorner180 = rot90(templatecannycorner90);
% templatecannycorner270 = rot90(templatecannycorner180);
% %ecken erkennen mit template matching
% obenlinks   = normxcorr2(templatecannycorner, inputmorph);
% untenlinks   = normxcorr2(templatecannycorner90, inputmorph);
% untenrechts = normxcorr2(templatecannycorner180, inputmorph);
% obenrechts  = normxcorr2(templatecannycorner270, inputmorph);
% 
% imshow(obenlinks);
% figure;
% imshow(untenlinks);
% figure;
% imshow(untenrechts);
% figure;
% imshow(obenrechts);
% figure;
% 
clc;
clear;