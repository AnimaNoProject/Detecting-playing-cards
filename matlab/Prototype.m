% Prototype here please %

%1. Karten teilen/ 2 separate bilder erstellen mit je 1 Karte
%2. Geometrisch projezieren / homogenes Bild erhalten
%3. Template matching - resultat erhalten

input = imread('input/img07.jpg');
figure();
imshow(input);

tform = affine2d([1 0 0; .5 1 0; 0 0 1]); % transformations matrix?
%tinput = imwarp(input, tform);
%tinput = edge(input, 'Sobel');

xsobelfilter = [-1 0 1; -2 0 2; -1 0 1];
ysobelfilter = [-1 -2 -1; 0 0 0; 1 2 1] ;
%input = rgb2gray(input);
%input = edge(input, 'Canny');
xsobelfilter2 = imfilter(double(input), xsobelfilter);
ysobelfilter2 = imfilter(double(input), ysobelfilter);
phi = rad2deg(atan2(xsobelfilter2, ysobelfilter2));
%1.Canny Algorithmus
sigma = 0.22;
inputgrey = double(rgb2gray(input));
inputcanny = edge(inputgrey, 'Canny', sigma);
figure();
imshow(inputcanny);
g = double(input) .* inputcanny;
figure();
imshow(g);
%2. 
%binär bild erstellen
i = 1;
se = strel('square',5);
dilatedI = imdilate(inputcanny,se);

%Kmedian = medfilt2(tinput(1:2));
%figure();
%imshow(tinput);
%imshow(Kmedian);
%figure();
%imshow(input(:,:,1));
%figure();
%imshow(input(:,:,2));
%figure();
%imshow(input(:,:,3));
%figure();
%imshow(rgb2gray(input));

%input = imread('input/img01.jpg');
%inputgray = rgb2gray(input);
%BW = imbinarize(inputgray,'adaptive','ForegroundPolarity','dark','Sensitivity',0.4);
%imshow(BW);

%figure();

%[B,L] = bwboundaries(BW, 4,'holes');
%imshow(label2rgb(L, @jet, [.5 .5 .5]));

%figure();
%hold on;
%for k = 1:length(B)
%   boundary = B{k};
%   plot(boundary(:,2), boundary(:,1), 'w', 'LineWidth', 2)
%end
%hold off;
clear;
clc;
