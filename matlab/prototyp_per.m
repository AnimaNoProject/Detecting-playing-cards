% Prototype here please %

%1. Karten teilen/ 2 separate bilder erstellen mit je 1 Karte
%2. Geometrisch projezieren / homogenes Bild erhalten
%3. Template matching - resultat erhalten

% Original Image
input = imread('input/test_img_pers.jpg');
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


%%%%%%%%%%%%%%% perspective correction %%%%%%%%%%%%%%% 
r = [firstcorner(1) secondcorner(1) thirdcorner(1) fourthcorner(1)]';
c = [firstcorner(2) secondcorner(2) thirdcorner(2) fourthcorner(2)]';
% Kartenverhältnis 5:8
base = [5 0; 0 0; 5 8; 0 8];
tf = cp2tform([c r], base*2000,'projective');
[xf1, XData, YData] = imtransform(card_one_gray,tf);
figure;
imshow(xf1);
