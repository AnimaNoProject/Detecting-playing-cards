% lese Urpsungsbild ein IMG_6660.jpg
input = imread('input/test.jpg');
% Figure 1: Ursprungsbild
%figure, imshow(input), title('Inputbild');


binaryInput = im2bw(input);
%figure, imshow(binaryInput);
CC = bwconncomp(binaryInput);

% Dummy Image
BW2 = zeros(size(binaryInput)); 
%figure, imshow(BW2);
hold on

figure();

for k = 1:4 %// Loop through each object and plot it in white. This is where you can create individual figures for each object.  CC.NumObjects

    PixId = CC.PixelIdxList{k}; %// Just simpler to understand

    if size(PixId,1) == 1 %// If only one row, don't consider.        
        continue
    else
    BW2(PixId) = 255;
    %figure(k) %// Uncomment this if you want individual figures.
    imshow(BW2);
    %pause(.5) %// Only for display purposes.
    end
end


% hole groesste Zusammenhangskomponente
numPixels = cellfun(@numel,CC.PixelIdxList);
%sortedPixels = sort(numPixels,'descend');
[biggest, idx] = max(numPixels);

% erstelle Schwarzbild mit der Groeﬂe des Inputbilds
obereKarte = zeros(size(binaryInput));
% setze den Bereich der maximalen Zusammenhangskomponente auf weiﬂ
obereKarte(CC.PixelIdxList{idx}) = 1;
figure, imshow(obereKarte), title('Obere Karte');

% hier m¸ssen wir uns noch etwas f¸r den Index ¸berlegen, da 1 hier nur
% gesch‰tzt ist (kˆnnte nat¸rlich auch was anderes sein). Eventuell
% sortieren wir die Liste, dann ist das zweite Element immer die untere
% Karte und das erste Lement die obere Karte
untereKarte = zeros(size(binaryInput));
untereKarte(CC.PixelIdxList{1}) = 1;
figure, imshow(untereKarte), title('Untere Karte');



















% % Canny Edge Detection mit edge() --> function will return all edges that are stronger than threshold.
% 
% % If you do not specify threshold, or if you specify empty
% % brackets ([]), edge chooses the value automatically. threshold is a
% % two-element vector in which the first element is the low threshold, and the second element
% % is the high threshold. If you specify a scalar, edge uses this value for the high value and uses threshold*0.4 for the low threshold.
% threshold = 0.5;
% % specify sigma, the standard deviation of the Gaussian filter. The default sigma is sqrt(2).
% sigma = sqrt(2);
% % transform image matrix to double only values for the edge() function
% input_grey = double(rgb2gray(input));
% % apply Canny Edge Detection; output will be a logical matrix
% input_canny = edge(input_grey, 'Canny', threshold, sigma);
% 
% 
% % apply dilation in order to make the lines more visible
% 
% % The argument SE is a structuring element object, or array of structuring element objects, returned by the strel or offsetstrel function. 
% se = strel('square',5);
% canny_dilated = imdilate(input_canny,se);
% figure, imshow(canny_dilated), title('Kantenbild mit anschlieﬂender Dilation, um die Kanten zu vervollst‰ndigen');
% 
% % put a bounding box over the two cards
% boundary = regionprops(canny_dilated, 'BoundingBox');
% boundingbox = boundary.BoundingBox;
% hold on;
% rectangle('Position',boundingbox,'EdgeColor','r','LineWidth',2);
% 
% croppedImage = imcrop(canny_dilated, boundary(1).BoundingBox);
% croppedImage = rot90(croppedImage);
% figure, imshow(croppedImage), title('Abgeschnittenes Bild');
% 
% % find all corner in the image
% %c = corner(croppedImage);
% %hold on;
% %figure();
% %imshow(c);




