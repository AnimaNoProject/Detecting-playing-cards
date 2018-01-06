%corrects the perspective of the 2 input cards
function [first_perspcorrected_card] = correctPerspectives(first_colored_img, first_gray_image)
[fcorner1, fcorner2, fcorner3, fcorner4]    = cornerDetection(first_gray_image);
first_perspcorrected_card                   = perspectiveCorrection(first_colored_img, fcorner1, fcorner2, fcorner3, fcorner4);
end
