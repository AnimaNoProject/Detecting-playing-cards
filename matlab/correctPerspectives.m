function [first_perspcorrected_card] = correctPerspectives(first_colored_img, first_gray_image)
%   Author: Jan Michael Laranjo
%   Detailed explanation:
%   INPUT:
%       first_colored_img   --> RGB image of the first card
%       first_gray_image    --> grayscale image of the first card 
%   OUTPUT:
%       first_perspcorrected_card--> orthogonal projection of the card in
%   change this card perspective projection into orthogonal projection
[fcorner1, fcorner2, fcorner3, fcorner4]    = cornerDetection(first_gray_image);
first_perspcorrected_card                   = perspectiveCorrection(first_colored_img, fcorner1, fcorner2, fcorner3, fcorner4);
end
