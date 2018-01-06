%final implementaion
function [result] = main(img_path)
%   Author: Jan Michael Laranjo
%   Detailed explanation:
%   INPUT:
%       img_path    --> RGB output image of the geometric transformation
%   OUTPUT:
%       result      --> is the textual based answer for this current round
%   simulates a round of the game by reading the path of the picture.
%   Afterwards the cards get splitted. The cards have a perspective
%   projection and by correcting the perspective to orthogonal projection
%   the values of the cards can be determined by template matching.
%   Finally it can be determined a 'Stich' occured.
%
%read the image
tic;
clc;
image = imread(img_path);
% [height, width, dimension] = size(image);
% if(height > 2000 && width > 2000)
%     image = imresize(image, 0.1);
% end
% if(height > 1000 && width > 1000)
%     image = imresize(image, 0.32);
% end
%splitCards results are 2 binary images
%the first card is the bigger one
[first_binary_image, second_binary_image] = splitCards(image);
%get the colored result of the split cards
[first_rgb_image, second_rgb_image] = getSplitColoredCard(image, first_binary_image, second_binary_image);
%correct the perspective of the 2 cards
[first_perspcorrected_card]     = correctPerspectives(first_rgb_image, first_binary_image, second_rgb_image, second_binary_image);
[second_perspcorrected_card]    = geom_transf_lowercard(first_binary_image,first_rgb_image);

%start template matching to determine the value of the top and bottom
%card
<<<<<<< HEAD
fprintf('values of cards determined with template matching\n');
=======
fprintf('determining first card');
>>>>>>> 619b5b3e7eecfbd76aa93811ced32958cf895d45
[index_symbol_top, index_letter_top]        = decideCard(first_perspcorrected_card, 1);
fprintf('determining second card');
[index_symbol_bottom, index_letter_bottom]  = decideCard(second_perspcorrected_card, 0);

%finally the result of the game can be determined
fprintf('result of the game is evaluated\n');
result = getResultOfMatch(index_symbol_top, index_letter_top, index_symbol_bottom, index_letter_bottom);
toc
end

function [first_rgb_image, second_rgb_image] = getSplitColoredCard(image, first_binary_image, second_binary_image)
    first_rgb_image     = image;
    second_rgb_image    = image;    
    first_rgb_image(:,:,1) = double(image(:,:,1)) .* first_binary_image(:,:);
    first_rgb_image(:,:,2) = double(image(:,:,2)) .* first_binary_image(:,:);
    first_rgb_image(:,:,3) = double(image(:,:,3)) .* first_binary_image(:,:);

    second_rgb_image(:,:,1) = double(image(:,:,1)) .* second_binary_image(:,:);
    second_rgb_image(:,:,2) = double(image(:,:,2)) .* second_binary_image(:,:);
    second_rgb_image(:,:,3) = double(image(:,:,3)) .* second_binary_image(:,:);
end