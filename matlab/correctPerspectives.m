%corrects the perspective of the 2 input cards
function [first_perspcorrected_card] = correctPerspectives(first_colored_img, first_gray_image,second_colored_img, second_gray_img)
[fcorner1, fcorner2, fcorner3, fcorner4]    = cornerDetection(first_gray_image);
first_perspcorrected_card                   = perspectiveCorrection(first_colored_img, fcorner1, fcorner2, fcorner3, fcorner4);
second_perspcorrected_card                  = geom_transf_lowercard(second_gray_img);
% [scorner1, scorner2, scorner3, scorner4]  = cornerDetection(second_gray_img);
% figure();
% imshow(second_gray_img);
% hold on;
% plot(scorner1(2),scorner1(1), '+');
% plot(scorner2(2),scorner2(1), '*');
% plot(scorner3(2),scorner3(1), 's');
% plot(scorner4(2),scorner4(1), 'o');
% hold off;
% 
% corners = correctCorner(scorner1,scorner2, scorner3, scorner4);
% 
% figure();
% imshow(second_gray_img);
% hold on;
% plot(corners(1,2),corners(1,1), '+');
% plot(corners(2,2),corners(2,1), '*');
% plot(corners(3,2),corners(3,1), 's');
% hold off;
end
