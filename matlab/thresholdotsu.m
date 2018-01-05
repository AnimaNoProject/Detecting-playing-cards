function [ binary_image ] = thresholdotsu( gray_image )
%THRESHOLDOTSU Threshhold nach Otsu
%   Author:
%   Thorsten Korpitsch, 1529243
%   
%   Eingabe: Graustufenbild
%   Ausgabe: Binärbild
%      
%   Die Funktion wandelt ein Graustufenbild in ein Binärbild um
%   mittels der Methode von Otsu.
%
    histogramCounts = histcounts(gray_image(:), 256);

    total = sum(histogramCounts);  % Gesamtzahld der Pixel

    sum_bg = 0;                    % Summe (gewichtet) Hintergrund              
    w_bg = 0;                      % gewichteter Hintergrund
    max_var = 0.0;                 % max_var "Between Class Variance"
    w_fg = 0;                      % gewichteter Vordergrund
    m_fg = 0;                      % durchschnitt Vordergrund
    m_bg = 0;                      % durchschnitt Hintergrund
   
    % Grauwert mit der jeweiligen Anzahl der Pixel die den Grauwert haben
    % aufsummieren
    sum1 = dot((0:255), histogramCounts); 
    
    % Iterieren durch alle Grauwerte
    for gray=1:256
        
        % Pixel des aktuellen Grauwerts zum Hintergrund aufsummieren
        w_bg = w_bg + histogramCounts(gray);
        
        % Pixel die nicht zum Hintergrund gehoeren sind der Vordergrund
        w_fg = total - w_bg;
        
        % gewichtete Summe des Hintergrunds aufsummieren
        sum_bg = sum_bg +  (gray-1) * histogramCounts(gray);
        
        % Durchschnitt des Hintergrunds
        m_bg = sum_bg / w_bg;
        
        % Durchschnitt des Vordergrunds
        m_fg = (sum1 - sum_bg) / w_fg;
        
        % "Between Class Variance" berechnen
        between_var = w_bg * w_fg * (m_bg - m_fg) * (m_bg - m_fg);
        
        % Wenn die "Between Class Variance" größer als das Maximum ist
        % wird der Grauwert zum Threshold und die Distanz zum neuen Maximum
        if (between_var >= max_var ) 
            threshhold = gray;
            max_var = between_var;
        end
    end
    
    % Binaerbild zurueckgeben
    binary_image = (gray_image >= threshhold);
end

