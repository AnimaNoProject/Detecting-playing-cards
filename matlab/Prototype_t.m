% Original Image %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
input = imread('input/test_img.jpg');
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
card_one = rotateCard(card_one);
card_two = rotateCard(card_two);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Scale Cards %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
card_one = scaleCard(card_one);
card_two = scaleCard(card_two);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

template = imread('input/templ_pik_koenig.png');

template = imresize(template, 0.5);

% apply templete matching using power of the image
result1=tmc(card_one, template);

figure,
subplot(2,2,1),imshow(template);title('Template');
subplot(2,2,2),imshow(card_one);title('Target');
subplot(2,2,3),imshow(result1);title('Matching Result using tmc');


% apply templete matching using DC components of the image
result2=tmc(card_two, template);

figure,
subplot(2,2,1),imshow(template);title('Template');
subplot(2,2,2),imshow(card_two);title('Target');
subplot(2,2,3),imshow(result2);title('Matching Result using tmc');