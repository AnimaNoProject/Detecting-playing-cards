% Prototype here please %

<<<<<<< HEAD
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
=======
input = imread('input/img01.jpg');
inputgray = rgb2gray(input);
BW = imbinarize(inputgray,'adaptive','ForegroundPolarity','dark','Sensitivity',0.4);
imshow(BW);

figure();

[B,L] = bwboundaries(BW, 4,'holes');
imshow(label2rgb(L, @jet, [.5 .5 .5]));

%figure();
%hold on;
%for k = 1:length(B)
%   boundary = B{k};
%   plot(boundary(:,2), boundary(:,1), 'w', 'LineWidth', 2)
%end
%hold off;
>>>>>>> e3bcef6d83048ed9e327f0f54020223a57e1c037
