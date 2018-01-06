function [ card_string ] = card2string(symbol, value)
%   card2string
%   Author: Thorsten Korpitsch
%   returns string of card
if (symbol == 1)
     card_symbol = 'Karo';
 elseif (symbol == 2 )
     card_symbol = 'Herz';
 elseif (symbol == 3 )
     card_symbol = 'Kreuz';
 elseif (symbol == 4 )
     card_symbol = 'Pik';
end;

 if (value == 1)
     card_value = 'Ass';
 elseif (value == 2 )
     card_value = 'Zehn';
 elseif (value == 3 )
     card_value = 'Koenig';
 elseif (value == 4 )
     card_value = 'Dame';
 elseif (value == 5 )
     card_value = 'Bube';
 end;  
 
 card_string = ['(' card_symbol ' ' card_value ')'];
end

