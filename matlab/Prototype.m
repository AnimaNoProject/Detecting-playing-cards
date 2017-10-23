% Prototype here please %

input = imread('input/img01.jpg');
input = rgb2gray(input);
BW = imbinarize(input);

figure();

[B,L] = bwboundaries(BW,'noholes');
imshow(label2rgb(L, @jet, [.5 .5 .5]))
hold on
for k = 1:length(B)
   boundary = B{k};
   plot(boundary(:,2), boundary(:,1), 'w', 'LineWidth', 2)
end