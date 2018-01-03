function [transformedImages] = geometricTransformation(image, matrix)
    mappedImage = mapping(image, matrix);
end

function [mappedImage] = mapping(image, matrix)
    mappedImage = [];
    %determine new bounds in transformed image
    %upperleft
    [lengthX lengthY] = size(image(:,:,1));
    upperLeft   = round(matrix * [1;1]);
    upperRight  = round(matrix * [lengthX;1]);
    lowerLeft   = round(matrix * [1;lengthY]);
    lowerRight  = round(matrix * [lengthX;lengthY]);
    
    %need to shift the boundaries, such that every corner is positive
    correctionVector = getCorrectionVector(upperLeft, upperRight, lowerLeft, lowerRight);
    
    %shift boundaries such that every point is positive
    upperLeftMapped   = upperLeft  + correctionVector;
    upperRightMapped  = upperRight + correctionVector;
    lowerLeftMapped   = lowerLeft  + correctionVector;
    lowerRightMapped  = lowerRight + correctionVector;
    
    clear upperLeft upperRight lowerLeft lowerRight
    
    width   = max([upperLeftMapped(2) upperRightMapped(2) lowerLeftMapped(2) lowerRightMapped(2)]);
    height  = max([upperLeftMapped(1) upperRightMapped(1) lowerLeftMapped(1) lowerRightMapped(1)]); 
    mappedImage = zeros(height + 1, width + 1,3);
    [rows, columns] = size(image(:,:,1));
    for y = 1 : height
        for x = 1 : width
            %determine coord in original picture
            coordInOriginalPicture  = getOriginalPoint(y, x, correctionVector, matrix);
            %punkt muss innerhalb der grenze des original bildes sein
            %sonst wird der punkt verworfen
            originY = coordInOriginalPicture(1);
            originX = coordInOriginalPicture(2);
            %[originX originY]
            if(min(min(coordInOriginalPicture)) > 0 && originY < rows && originX < columns)
                rgbValue                = image(coordInOriginalPicture(1),coordInOriginalPicture(2),:);
                mappedImage(y,x,:)      = rgbValue;
            end
        end
    end
%     for y = 1 : rows
%         for x = 1 : columns
%             rgbValue            = image(y,x,:);
%             newCoordinate       = getNewCoordinate(y, x, correctionVector, matrix);
%             mappedImage(newCoordinate(1), newCoordinate(2), :) = rgbValue(1,1,:);
%         end
%     end
end

function [correctionVector] = getCorrectionVector(upperLeft, upperRight, lowerLeft, lowerRight)
correctionVector = [0;0];
    %value is out of positive bounds
    %need transform 
    if(containsNegativeValue(upperLeft))
        correctionVector = getMaxVector(correctionVector, getCurrentCorrectionVector(upperLeft));
    end
    if(containsNegativeValue(upperRight))
        correctionVector = getMaxVector(correctionVector, getCurrentCorrectionVector(upperRight));
    end
    if(containsNegativeValue(lowerLeft))
        correctionVector = getMaxVector(correctionVector, getCurrentCorrectionVector(lowerLeft));
    end
    if(containsNegativeValue(lowerRight))
        correctionVector = getMaxVector(correctionVector, getCurrentCorrectionVector(lowerRight));
    end
end

function [maxVector] = getMaxVector(v1,v2)
    maxVector(1,1) = max(v1(1),v2(1));
    maxVector(2,1) = max(v1(2),v2(2));
end

function [containsNegativeCoordinate] = containsNegativeValue(coordinate)
    containsNegativeCoordinate = coordinate(1) < 0 || coordinate(2) < 0;
end

function [correctionVector] = getCurrentCorrectionVector(vector)
    correctionVector = [0;0];
    if(vector(1)<0)
        correctionVector(1,1) = -vector(1) + 1;
        correctionVector(2,1) = correctionVector(2,1);
    end
    if(vector(2)<0)
        correctionVector(1,1) = correctionVector(1,1);
        correctionVector(2,1) = -vector(2) + 1;
    end
    if(isempty(correctionVector))
        correctionVector = [0;0];
    end
end

function [newCoordinate] = getNewCoordinate(y, x, correctionVector, matrix)
    coordinate          = [y;x];
    mappedCoordinate    = matrix * coordinate;
    newCoordinate       = round(mappedCoordinate) + correctionVector;
end

function [originalPoint] = getOriginalPoint(y, x, correctionVector, matrix)
    coordinate          = [y;x];
    mappedCoordinate    = coordinate - correctionVector;
    %inverse matrix for rotation
    %can be extended for every other affine transformation
    inverseMatrix       = [matrix(1,1) -matrix(1,2);
                           -matrix(2,1) matrix(2,2)];
    %use nearest neighbour interpolation
    originalPoint       = round(inverseMatrix * coordinate); 
end