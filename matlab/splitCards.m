function [card_one, card_two] = splitCards(input_picture)
%SPLITCARDS Karten mittels Otsu in ein Binaerbild umwandeln
%           dann mit Connected Components trennen
%           gibt 2 Karten, als Binärbilder, zurueck:
%           card_one: untere Karte
%           card_two: obere Karte
%   Author:
%   Thorsten Korpitsch
    % Bild in Graustufen umwandeln
    input_gray = rgb2gray(input_picture);
    
    % nach Otsu in ein Binaerbild umwandeln
    binaryInput = thresholdotsu(input_gray);
    
    % Connected Components auf das Binärbild anwenden
    CC = bwconncomp(binaryInput);

    % Connected Components nach der Anzahl der Pixel sortieren
    numPixels = cellfun(@numel,CC.PixelIdxList);
    [biggest, idx] = sort(numPixels,'descend');

    % Dummy Bild erzeugen
    card_one = zeros(size(binaryInput));
    
    % Pixel groessten Zusammenhangskomponente auf 1 Setzen
    card_one(CC.PixelIdxList{idx(1)}) = 1;
    % Loecher fuellen
    filled_first = imfill(card_one, 'holes');
    
    % Dummy Bild erzeugen
    card_two = zeros(size(binaryInput));
    
    % Pixel der 2. groessten Zusammenhangskomponente auf 1 Setzen
    card_two(CC.PixelIdxList{idx(2)}) = 1;
    % Loecher fuellen
    filled_second = imfill(card_two, 'holes');

    % Die Karte mit "mehr" Pixel ist die oberste Karte, die andere die
    % Untere
    if(sum(filled_first) > sum(filled_second))
        card_one = filled_first;
        card_two = filled_second;
    else
        card_one = filled_second;
        card_two = filled_first;
    end;
end

