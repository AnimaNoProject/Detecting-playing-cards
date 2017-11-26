function [ gray_image ] = toGray( rgb_image )
%TOGRAY rgb to gray with desaturation
    gray_image = zeros(size(rgb_image,1), size(rgb_image,2));
    for x=1:size(rgb_image,1)
       for y=1:size(rgb_image,2)
            gray_image(x,y) = (max([rgb_image(x,y,1), rgb_image(x,y,2),rgb_image(x,y,3)]) + min([rgb_image(x,y,1), rgb_image(x,y,2),rgb_image(x,y,3)]))/2;
       end
    end
end

