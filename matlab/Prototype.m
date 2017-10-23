% Prototype here please %

%1. Karten teilen/ 2 separate bilder erstellen mit je 1 Karte
%2. Geometrisch projezieren / homogenes Bild erhalten
%3. Template matching - resultat erhalten




input = imread('input/img.jpg');
tform = affine2d([1 0 0; .5 1 0; 0 0 1]); % transformations matrix?
%tinput = imwarp(input, tform);
%tinput = edge(input, 'Sobel');

xsobelfilter = [-1 0 1; -2 0 2; -1 0 1];
ysobelfilter = [-1 -2 -1; 0 0 0; 1 2 1] ;

y = fspecial('sobel')

tinput = imfilter(imfilter((input), xsobelfilter), ysobelfilter);
%tinput(tinput > 200)  = 255;

%Kmedian = medfilt2(tinput(1:2));
imshow(input);
imshow(Kmedian);
figure();
imshow(input(:,:,1));
figure();
imshow(input(:,:,2));
figure();
imshow(input(:,:,3));
figure();
imshow(rgb2gray(input));