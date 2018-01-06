%final implementaion
function [] = main(folder_path)
%   Author: Jan Michael Laranjo
%   Detailed explanation:
%   INPUT:
%       folder_path    --> the path contains every picture for every round,
%   which contains 2 cards, which must be separated first. Afterwards the
%   projections have to be corrected and finally the cards can be
%   determined to get result of the current game.
files = dir(folder_path);
%first player has the bottom card
%isBottomCardFirstPlayer is true, when the first player throws the first
%card, else means that the second player starts first
isBottomCardFirstPlayer = 1;
sumFirstPlayer          = 0;
sumSecondPlayer         = 0;
for i = 3 : length(files)
    round       = i - 2;
    fileName    = [folder_path '\' files(i).name];
    fprintf(['--- Spielzug ' num2str(round) '---\n']);
    if(isBottomCardFirstPlayer)
        fprintf('Erster Spieler wirft zuerst\n');
    else
        fprintf('Zweiter Spieler wirft zuerst\n');
    end
    [textualRoundResult, pointsTop, pointsBottom] = simulateCurrentRound(fileName);
    isBottomCardWin = pointsBottom > pointsTop;
    fprintf(textualRoundResult);
    if(isBottomCardWin && isBottomCardFirstPlayer)   
        %bottom card(winner) was thrown by the first player
        isBottomCardFirstPlayer = 1;
        sumFirstPlayer  = sumFirstPlayer + pointsBottom + pointsTop;
        fprintf('Erster Spieler hat mit der unteren Karte gewonnen. Erster Spieler wirft als Erster in der nächste Runde!\n'); 
    elseif(isBottomCardWin && ~isBottomCardFirstPlayer)
        %bottom card(winner) was thrown by the second player
        isBottomCardFirstPlayer = 0;
        sumFirstPlayer  = sumFirstPlayer + pointsBottom + pointsTop;
        fprintf('Zweiter Spieler hat mit der unteren Karte gewonnen. Zweiter Spieler wirft als Erster in der nächste Runde!\n'); 
    elseif(~isBottomCardWin && isBottomCardFirstPlayer)
        %top card(winner) was thrown by the second player 
        isBottomCardFirstPlayer = 0;
        sumSecondPlayer = sumSecondPlayer + pointsBottom + pointsTop;
        fprintf('Zweiter Spieler hat mit der oberen Karte gewonnen. Zweiter Spieler wirft als Erster in der nächste Runde!\n'); 
    elseif(~isBottomCardWin && ~isBottomCardFirstPlayer)
        %top card(winner) was thrown by the first player 
        isBottomCardFirstPlayer = 1;
        sumSecondPlayer = sumSecondPlayer + pointsBottom + pointsTop;
        fprintf('Erster Spieler hat mit der unteren Karte gewonnen. Erster Spieler wirft als Erster in der nächste Runde!\n'); 
    end
    currentPoints = ['aktueller Punktestand: \nSpieler 1: ' num2str(sumFirstPlayer) '\nSpieler 2: ' num2str(sumSecondPlayer) '\n'];
    fprintf([currentPoints '\n']);
end

end
 

function [textualRoundResult, pointsTop, pointsBottom] = simulateCurrentRound(img_path)
%   Author: Jan Michael Laranjo
%   Detailed explanation:
%   INPUT:
%       img_path    --> the path of the image for the current round
%   OUTPUT:
%       result      --> is the textual based answer for this current round
%   simulates a round of the game by reading the path of the picture.
%   Afterwards the cards get splitted. The cards have a perspective
%   projection and by correcting the perspective to orthogonal projection
%   the values of the cards can be determined by template matching.
%   Finally it can be determined a 'Stich' occured. The output 'result' is
%   just the textual result of the current round
%
%read the image
image = imread(img_path);
%splitCards results are 2 binary images
%the first card is the bigger one
[second_binary_image, first_binary_image] = splitCards(image);
%get the colored result of the split cards
[first_rgb_image, second_rgb_image] = getSplitColoredCard(image, first_binary_image, second_binary_image);
%correct the perspective of the 2 cards
[first_perspcorrected_card]     = correctPerspectives(first_rgb_image, first_binary_image);
[second_perspcorrected_card]    = geom_transf_lowercard(second_binary_image, second_rgb_image);

%start template matching to determine the value of the top and bottom
%card
fprintf('Wert der Karten werden bestimmt\n');
[index_symbol_top, index_letter_top]        = decideCard(first_perspcorrected_card, 1);
[index_symbol_bottom, index_letter_bottom]  = decideCard(second_perspcorrected_card, 0);

%finally the result of the game can be determined
fprintf('Die Runde wird ausgewertet.\n');
[textualRoundResult, pointsTop, pointsBottom] = getResultOfMatch(index_symbol_top, index_letter_top, index_symbol_bottom, index_letter_bottom); 
end