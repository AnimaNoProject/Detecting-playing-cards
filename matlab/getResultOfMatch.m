function [textualRoundResult,pointsTop,pointsBottom] = getResultOfMatch(index_symbol_top, index_letter_top, index_symbol_bottom, index_letter_bottom)
%   Author: Jan Michael Laranjo
%   Detailed explanation:
%   INPUT:
%       index_symbol--> RGB output image of the geometric transformation
%       index_letter--> RGB image. Basically a snippet of the original card.
%                       Represents a symbol or a letter. 
%   OUTPUT:
%       result      --> is the textual based answer for this current round
%        
%   is responsible for the game logic.The method determines which card gives
%   the 'Stich'.
% Auswertung der Ergebnisvektoren und Ausgabe auf der Konsole
    topCardValue    = card2string(index_symbol_top, index_letter_top);
    bottomCardValue = card2string(index_symbol_bottom, index_letter_bottom);
    pointsTop       = calculatePoints(topCardValue);
    pointsBottom    = calculatePoints(bottomCardValue);
    textualRoundResult = ['Obere Karte: ' topCardValue ' vs. Untere Karte: ' bottomCardValue '\n'];
end

function [points] = calculatePoints(cardValue)
%   Author: Jan Michael Laranjo
%   Detailed explanation:
%   INPUT:
%       index_symbol--> RGB output image of the geometric transformation
%       index_letter--> RGB image. Basically a snippet of the original card.
%                       Represents a symbol or a letter. 
%   OUTPUT:
%       result      --> is the textual based answer for this current round
%        
%   determines how much points a card gives
points       = 0;
if(contains(cardValue, 'Ass'))
points = 11;
elseif(contains(cardValue, 'Zehn'))
points = 10;
elseif(contains(cardValue, 'Koenig'))
points = 4;
elseif(contains(cardValue, 'Dame'))
points = 3;
elseif(contains(cardValue, 'Bube'))
points = 2;
end
end