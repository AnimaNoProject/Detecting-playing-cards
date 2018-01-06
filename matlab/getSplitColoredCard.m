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