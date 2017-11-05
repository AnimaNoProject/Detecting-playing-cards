input = imread('input/IMG_6660.jpg');
figure();
imshow(input);
%wende canny algorithmus an
sigma = 0.5;
inputgrey = double(rgb2gray(input));
inputcanny = edge(inputgrey, 'Canny', sigma);
figure();
imshow(inputcanny);
%morphologie nutzen damit die kanten besser ausschauen

se = strel('square',5);
%se = strel('disk',10);
inputmorph = imdilate(inputcanny,se);
figure();
imshow(inputmorph);
%noise reduzieren
inputfilt = medfilt2(inputmorph);
%finde ecken
corners = corner(inputmorph);
%für jeden punkt berechne den winkel
xsobelfilter = [-1 0 1; -2 0 2; -1 0 1];
ysobelfilter = [-1 -2 -1; 0 0 0; 1 2 1] ;
xsobel = imfilter(double(inputfilt), xsobelfilter);
ysobel = imfilter(double(inputfilt), ysobelfilter);
phi = rad2deg(atan2(xsobel, ysobel));

clc;
