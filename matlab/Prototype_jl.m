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
%boundingbox
boundary = regionprops(inputfilt, 'BoundingBox');
boundingbox = boundary.BoundingBox;
hold on;
imshow(inputmorph);
rectangle('Position',boundingbox,'EdgeColor','r','LineWidth',2);
figure;
%corner template bekommen
templatecorner         = imread('input/corner_template.png');
templategreycorner     = double(rgb2gray(templatecorner));
templatecannycorner   = edge(templategreycorner, 'Canny', sigma);
imshow(templatecannycorner);
figure;
%ecken  3 mal drehen
templatecannycorner90 = rot90(templatecannycorner);
templatecannycorner180 = rot90(templatecannycorner90);
templatecannycorner270 = rot90(templatecannycorner180);
%ecken erkennen mit template matching
obenlinks   = normxcorr2(templatecannycorner, inputmorph);
untenlinks   = normxcorr2(templatecannycorner90, inputmorph);
untenrechts = normxcorr2(templatecannycorner180, inputmorph);
obenrechts  = normxcorr2(templatecannycorner270, inputmorph);

imshow(obenlinks);
figure;
imshow(untenlinks);
figure;
imshow(untenrechts);
figure;
imshow(obenrechts);
figure;

clc;
clear;