function [ scaled_card ] = scaleCard( card )
%SCALECARD Summary of this function goes here
%   Detailed explanation goes here

%     card_bw = imbinarize(rgb2gray(card), 0.47);
    card_bw = im2bw(rgb2gray(card));
    boundingbox     = regionprops(card_bw, 'BoundingBox');
    boxproperties   = boundingbox.BoundingBox;
    left            = round(boxproperties(1));
    top             = round(boxproperties(2));
    width           = boxproperties(3);
    height          = boxproperties(4);
    
    scaled_card = imcrop(card, [left, top, width, height]);
end

