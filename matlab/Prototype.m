% Prototype here please %

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