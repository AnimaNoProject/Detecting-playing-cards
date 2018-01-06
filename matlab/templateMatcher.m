function maxcorr = templateMatcher( target, template, isTOP)
%TMC Summary of this function goes here
%   Author: Andreas Brunner
%   Detailed explanation:
%   
%   INPUT:
%       target --> RGB output image of the geometric transformation
%       template --> RGB image. Basically a snippet of the original card.
%                     Represents a symbol or a letter. 
%
%   OUTPUT:
%       maxcorr --> maximum correlation value of the calculated correlation
%                       matrix
% 
%   In every iteration of the for-loop a snippet is cut out of the target
%   image. It has the exact the same size as the template image. With the
%   help of these two, in every iteration a correlation coefficient is
%   calculated and stored in a matrix.
%   The higher the correlation value, the higher the chance of the
%   snippet to be the same as the template symbol or letter. 
% 
%   After both for-loops the biggest correlation coefficient will be
%   retuned by the function.
%   tmcTopCard() is optimized for cards that are on top of each move of the
%   game
    
    % Decide how much of the Target needs to be scanned depending if we
    % are sure that we have the full picture
    % 1 for upper card
    % 2 for lower card
    factor = 0.5;
    if (isTOP == 1)
        factor = 0.3;
    end;

    % convert both images to grayscale images with the help of Otsu Thresholding
    A = thresholdotsu(rgb2gray(target));
    B = thresholdotsu(rgb2gray(template));

    % create correlation matrix. This matrix will be filled afterwards.
    corr_map = zeros([size(A,1),size(A,2)]);
 
    % for-loop for iterating through the target image. Every iteration a
    % other part of the target image is beeing processed.
    for i = 1:(size(A,1)*factor)-size(B,1)
        for j = 1:(size(A,2)*factor)-size(B,2)
            % take a snippet of the target image that has the same size
            snippet = A(i:i+size(B,1)-1, j:j+size(B,2)-1);
            
            % calculate the correlation value
            a = snippet - mean2(snippet);
            b = B - mean2(B);
            r = sum(sum(a.*b))/sqrt(sum(sum(a.*a))*sum(sum(b.*b)));
            % add correlation value to the matrix
            corr_map(i,j) = r;
        end
    end

    % find the maximum value of the correlation matrix
    maxpt = max(corr_map(:));
    maxcorr = maxpt;
end



