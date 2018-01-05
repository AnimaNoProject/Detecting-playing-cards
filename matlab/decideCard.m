function [value_symbol, index_symbol, value_letter, index_letter] = decideCard( target, isTOP)
%   Author: Jan Michael Laranjo
%   Detailed explanation:
%   INPUT:
%       target      --> RGB output image of the geometric transformation
%       template    --> RGB image. Basically a snippet of the original card.
%                       Represents a symbol or a letter. 
%       isTOP       --> flag to determine if the card is the top card or
%                       the bottom card
%   OUTPUT:
%       value_symbol--> represents the value of the symbol
%       index_symbol--> index of the symbol which is associated with 'Karo',
%                       'Herz', 'Kreuz', 'Pik'
%       value_letter--> represents the correlction of the letter
%       index_letter--> index of the symbol which is associated with 'Ass',
%                       'Zehn', 'Koenig', 'Dame', 'Bube'
%   For every input picture the value of the card is determined by template 
%   matching. The input card is matched with every symbol and letter and
%   the best matching is used for determining. The results can be used to
%   indicate which value the card is.
%
%resize the target in preparation for the matching 
target = imresize(target, 0.5, 'nearest');
%read every template and scale the templates in preparation for the matching 
template_karo   = imresize(imread('input/Datensaetze/Templates/karo.png'), 0.7, 'nearest');
template_herz   = imresize(imread('input/Datensaetze/Templates/herz.png'), 0.7, 'nearest');
template_pik    = imresize(imread('input/Datensaetze/Templates/pik.png'), 0.7, 'nearest');
template_kreuz  = imresize(imread('input/Datensaetze/Templates/kreuz.png'), 0.7, 'nearest');

template_ass    = imresize(imread('input/Datensaetze/Templates/ass.png'), 0.7, 'nearest');
template_zehn   = imresize(imread('input/Datensaetze/Templates/zehn.png'), 0.7, 'nearest');
template_koenig = imresize(imread('input/Datensaetze/Templates/koenig.png'), 0.7, 'nearest');
template_dame   = imresize(imread('input/Datensaetze/Templates/dame.png'), 0.7, 'nearest');
template_bube   = imresize(imread('input/Datensaetze/Templates/bube.png'), 0.7, 'nearest');

%create a result vector
symbol(1) = templateMatcher(target, template_karo, isTOP); 
symbol(2) = templateMatcher(target, template_herz, isTOP); 
symbol(3) = templateMatcher(target, template_kreuz, isTOP); 
symbol(4) = templateMatcher(target, template_pik, isTOP); 
[value_symbol, index_symbol] = max(symbol);

letter(1) = templateMatcher(target, template_ass, isTOP); 
letter(2) = templateMatcher(target, template_zehn, isTOP); 
letter(3) = templateMatcher(target, template_koenig, isTOP); 
letter(4) = templateMatcher(target, template_dame, isTOP); 
letter(5) = templateMatcher(target, template_bube, isTOP); 
[value_letter, index_letter] = max(letter);
end