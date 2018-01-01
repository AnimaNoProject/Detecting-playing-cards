function [correctCorners] = correctCorner(corner1, corner2, corner3, corner4)
    if(isCorrectEdge(corner1, [corner2;corner3;corner4]))
        correctCorners = getCorrectCorners(corner1, [corner2;corner3;corner4]);
    elseif(isCorrectEdge(corner2, [corner1;corner3;corner4]))
        correctCorners = getCorrectCorners(corner2, [corner1;corner3;corner4]);
    elseif(isCorrectEdge(corner3, [corner1;corner2;corner4]))
        correctCorners = getCorrectCorners(corner3, [corner1;corner2;corner4]);
    elseif(isCorrectEdge(corner4, [corner1;corner2;corner3]))
        correctCorners = getCorrectCorners(corner4, [corner1;corner2;corner3]);
    end
end

function [isCorrectEdge] = isCorrectEdge(currentCorner, corners)
    u = norm(corners(1,:) - currentCorner);
    v = norm(corners(2,:) - currentCorner);
    w = norm(corners(3,:) - currentCorner);
    isRatio1 = isRatioCorrect(u,v);
    isRatio2 = isRatioCorrect(u,w);
    isRatio3 = isRatioCorrect(v,w);
    if(isRatio1 || isRatio2 || isRatio3)
        isCorrectEdge = 1;
    else
        isCorrectEdge = 0;
    end
end

% u > v && u:v = 5:8
function [isRatioCorrect] = isRatioCorrect(u, v)
    ratio = (8 * u) / (5 * v);
    threshold = 0.3;
    if((ratio > (1 - threshold)) && (ratio < (1 + threshold)))
        isRatioCorrect = 1;
    else
        isRatioCorrect = 0;
    end
end

function[correctCorners] = getCorrectCorners(currentCorner, corners)
    u = norm(corners(1,:) - currentCorner);
    v = norm(corners(2,:) - currentCorner);
    w = norm(corners(3,:) - currentCorner);
    if(isRatioCorrect(u,v)) 
        correctCorners = [currentCorner;corners(1,:);corners(2,:)];
    elseif (isRatioCorrect(u,w))
        correctCorners = [currentCorner;corners(1,:);corners(3,:)];
    elseif(isRatioCorrect(v,w))     
        correctCorners = [currentCorner;corners(2,:);corners(3,:)];
    end
end