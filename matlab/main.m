%final implementaion
function [result] = main(img_path)
    image = imread(img_path);
    %splitCards results are 2 binary images
    %the first card is the bigger one
    [first_binary_image, second_binary_image] = splitCards(image);
    %get the colored result of the split cards
    [first_rgb_image, second_rgb_image] = getSplitColoredCard(image, first_binary_image, second_binary_image);
    %get grayscale images 
%     first_gray_image    = rgb2gray(first_rgb_image);
%     second_gray_image   = rgb2gray(second_rgb_image);
    %correct the perspective of the 2 cards
    [first_perspcorrected_card]     = correctPerspectives(first_rgb_image, first_binary_image, second_rgb_image, second_binary_image);
    [second_perspcorrected_card]    = geom_transf_lowercard(first_binary_image,first_rgb_image);

    %start template matching
    [index_symbol, index_letter] = decideCard(first_perspcorrected_card, 1);
    
    clc;
    clear all;
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