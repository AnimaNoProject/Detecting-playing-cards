%returns the four corner of the card
function [firstcorner, secondcorner, thirdcorner, fourthcorner] = cornerDetection(first_binary_image)
    boundingbox     = regionprops(first_binary_image, 'BoundingBox');
    boxproperties   = boundingbox.BoundingBox;
    left            = round(boxproperties(1));
    top             = round(boxproperties(2));
    width           = boxproperties(3);
    height          = boxproperties(4);
    right           = round(boxproperties(1) + width) - 1;
    bottom          = round(boxproperties(2) + height) - 1;
    firstcorner     = -1;
    secondcorner    = -1;
    thirdcorner     = -1;
    fourthcorner    = -1;
    %get first corner from top left to top right
    for x = left : right
        value = first_binary_image(top, x);
        if(value == 1)
            firstcorner = [top, x];
            break;
        end
    end
    %get second corner from top left to bottom left
    for y = top : bottom
        value = first_binary_image(y, left);
        if(value == 1)
            secondcorner = [y, left];
            break;
        end
    end
    %get third corner top right to bottom right
    for y = top : bottom
        value = first_binary_image(y, right);
        if(value == 1)
            thirdcorner = [y, right];
            break;
        end
    end
    %get fourth corner from bottom left to bottom right
    for x = left : right
        value = first_binary_image(bottom, x);
        if(value == 1)
            fourthcorner = [bottom, x];
            break;
        end
    end
end