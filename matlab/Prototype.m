% Prototype here please %

%1. Karten teilen/ 2 separate bilder erstellen mit je 1 Karte
%2. Geometrisch projezieren / homogenes Bild erhalten
%3. Template matching - resultat erhalten

% Original Image
input = imread('input/test2.jpg');
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
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Harris Corner Detector
% C = corner(card_one_gray);
% figure();
% imshow(card_one_gray);
% hold on;
% plot(C(1:5,1), C(1:5,2), 'r*');
% hold off;

% figure();
% corners = detectHarrisFeatures(card_one_gray, 'MinQuality', 0.05);
% imshow(card_one_gray);
% hold on;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% SURF Feature Matching & Geometric Transformation 1st Card
original_one = rgb2gray(imread('input/pik_koenig.jpg'));
card_one_transformed = surf_transformation(original_one, card_one_gray);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% SURF Feature Matching & Geometric Transformation 2nd Card
original_two = rgb2gray(imread('input/pik_10.jpg'));
card_two_transformed = surf_transformation(original_two, card_two_gray);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Show both cards separated and transformed
imshowpair(card_one_transformed, card_two_transformed, 'Montage');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



