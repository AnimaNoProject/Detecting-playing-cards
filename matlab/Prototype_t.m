% Original Image %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
input = imread('input/test_img_per.png');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

input = imresize(input, 0.5, 'nearest');

[card_first, card_second] = splitCards(input);

%Get the RGB card from the Original image by dotmultiplying with the binary
%image %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
card_one = input;
card_two = input;

card_one(:,:,1) = double(card_one(:,:,1)) .* card_first(:,:);
card_one(:,:,2) = double(card_one(:,:,2)) .* card_first(:,:);
card_one(:,:,3) = double(card_one(:,:,3)) .* card_first(:,:);

card_two(:,:,1) = double(card_two(:,:,1)) .* card_second(:,:);
card_two(:,:,2) = double(card_two(:,:,2)) .* card_second(:,:);
card_two(:,:,3) = double(card_two(:,:,3)) .* card_second(:,:);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Scale Cards %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
card_one = scaleCard(card_one);
card_two = scaleCard(card_two);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Rotate Cards %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%card_one = rotateCard(card_one);
%card_two = rotateCard(card_two);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

card_bw = imbinarize(rgb2gray(card_one), 0.47);

boundingbox     = regionprops(card_bw, 'BoundingBox');
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
    value = card_bw(top, x);
    if(value == 1)
        firstcorner = [top, x];
        break;
    end
end
%get second corner from top left to bottom left
for y = top : bottom
    value = card_bw(y, left);
    if(value == 1)
        secondcorner = [y, left];
        break;
    end
end
%get third corner top right to bottom right
for y = top : bottom
    value = card_bw(y, right);
    if(value == 1)
        thirdcorner = [y, right];
        break;
    end
end
%get fourth corner from bottom left to bottom right
for x = left : right
    value = card_bw(bottom, x);
    if(value == 1)
        fourthcorner = [bottom, x];
        break;
    end
end
corners = [firstcorner;secondcorner;thirdcorner;fourthcorner];

r = [firstcorner(1) secondcorner(1) thirdcorner(1) fourthcorner(1)]';
c = [firstcorner(2) secondcorner(2) thirdcorner(2) fourthcorner(2)]';
%base = [0 0; 0 8; 5 0 ; 5 8];
 base = [5 0; 0 0; 5 8 ; 0 8];

tform = fitgeotrans([c r], base*200, 'projective');
card_one_corrected = imwarp(card_one, tform);
figure;
imshow(card_one_corrected);
figure;
imshow(card_one);

% Scale Cards %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
card_one = scaleCard(card_one);
card_two = scaleCard(card_two);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

template = imread('input/pik.png');

template = imresize(template, 0.5, 'nearest');

match1 = tmc(card_one, template);

match2 = tmc(card_two, template);