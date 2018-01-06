function [textualRoundResult isTopWin] = getResultOfMatch(index_symbol_top, index_letter_top, index_symbol_bottom, index_letter_bottom)
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
    textualRoundResult = ['Obere Karte: ' card2string(index_symbol_top, index_letter_top) ' vs. Untere Karte: ' card2string(index_symbol_bottom, index_letter_bottom) '\n'];
    isTopWin = 1;
end