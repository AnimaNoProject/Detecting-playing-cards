function [ threshhold ] = thresholdotsu( histogramCounts )
%THRESHOLDOTSU Threshhold Otsu
%   Author:
%   Thorsten Korpitsch, 1529243

    total = sum(histogramCounts);  % Gesamtzahld der Pixel

    sumB = 0;                      
    weightedBackground = 0;
    maximum = 0.0;
   
    % Grauwert mit der jeweiligen Anzahl der Pixel die den Grauwert haben
    % aufsummieren
    sum1 = dot( (0:255), histogramCounts); 
    
    % Iterieren durch alle Grauwerte
    for gray=1:256
        
        % Der gewichtete Hintergrund ergibt sich aus den 
        % Grauwerten von 1 bis zum gerade in der Schleife iterierten
        weightedBackground = weightedBackground + histogramCounts(gray);
        
        % Der gewichtete Hintergrund ergibt sich aus der Differenz
        % zwischen dem gewichteten Hintergrund und der Gesamtzahl an Pixel
        wF = total - weightedBackground;
       
        % Sollte der Gewichetete Hintergrund 0 sein oder der Vordergrund
        % springen wir sofort in die nächste Iteration
        %(--> Performanceverbesserung)
        if (weightedBackground == 0 || wF == 0)
            continue;
        end
        
        % Aufsummieren des Werts des Hintergrunds (Grauwert * Anzahl der
        % Pixel, welche den Grauwert  besitzen
        sumB = sumB +  (gray-1) * histogramCounts(gray);
        
        % Differenz zwischen dem Gesamten "Grauwert" und der Summe des
        % Hintergrunds dividiert durch den gewichteten Vordergrund
        mF = (sum1 - sumB) / wF;
        
        % Distanz zwischen den Segmenten (Vordergrund & Hintergrund)
        % Beschreibt wie Kompakt beide Segmente sind
        between = weightedBackground * wF * ((sumB / weightedBackground) - mF) * ((sumB / weightedBackground) - mF);
        
        % Wenn die "Distanz" größer als das Maximum ist
        % wird der Grauwert zum Threshold und die Distanz zum neuen Maximum
        if ( between >= maximum ) 
            threshhold = gray;
            maximum = between;
        end
    end
end

