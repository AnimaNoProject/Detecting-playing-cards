% Prototype here please %

input = imread('input/img01.jpg');
tform = affine2d([1 0 0; .5 1 0; 0 0 1]); % transformations matrix?
tinput = imwarp(input, tform);

imshow(input);
figure();
imshow(tinput);