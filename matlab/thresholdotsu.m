function [ threshhold ] = thresholdotsu( histogramCounts )
%THRESHOLDOTSU Threshhold Otsu
%   Detailed explanation goes here
    total = sum(histogramCounts);  % Total ammount of pixels

    sumB = 0;                      %  
    weightedBackground = 0;
    maximum = 0.0;
   
    sum1 = dot( (0:255), histogramCounts); 
    
    for gray=1:256
        
        weightedBackground = weightedBackground + histogramCounts(gray);
        
        wF = total - weightedBackground;
        
        if (weightedBackground == 0 || wF == 0)
            continue;
        end
        
        sumB = sumB +  (gray-1) * histogramCounts(gray);
        mF = (sum1 - sumB) / wF;
        
        between = weightedBackground * wF * ((sumB / weightedBackground) - mF) * ((sumB / weightedBackground) - mF);
        
        if ( between >= maximum ) 
            threshhold = gray;
            maximum = between;
        end
    end
end

