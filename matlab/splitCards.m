function [card_one, card_two] = splitCards(input_picture)
%SPLITCARDS Summary of this function goes here
%   Author:
%   Jan Michael Lajarno

       input_gray = rgb2gray(input_picture);
%        input_gray = toGray(input_picture);
    
%     imshowpair(input_gray2, input_gray, 'Montage');
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
      threshHold = thresholdotsu(histcounts(input_gray(:), 256));
% 
    % Binarized Image
%     binaryInput2 = imbinarize(input_gray, 0.47);
    
     binaryInput = (input_gray >= threshHold);
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
%     imshowpair(binaryInput, binaryInput2, 'Montage');
    
    % connected components
    CC = bwconncomp(binaryInput);
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


    % Sort biggest Components
    numPixels = cellfun(@numel,CC.PixelIdxList);
    [biggest, idx] = sort(numPixels,'descend');
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    %Fill the holes in the 2 components
    card_one = zeros(size(binaryInput));
    card_one(CC.PixelIdxList{idx(1)}) = 1;
    filled_first = imfill(card_one, 'holes');

    card_two = zeros(size(binaryInput));
    card_two(CC.PixelIdxList{idx(2)}) = 1;
    filled_second = imfill(card_two, 'holes');
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    %Decide which card is bigger by comparing the pixels
    if(sum(filled_first) > sum(filled_second))
        card_one = filled_first;
        card_two = filled_second;
    else
        card_one = filled_second;
        card_two = filled_first;
    end;
end

