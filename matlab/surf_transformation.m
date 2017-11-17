function [ transformed_image ] = surf_transformation( original, detected )
%surf_transformation Transforms a detected Image by using SURF Feature
%                    Matching
%   Transforms a detected Image by using SURF Feature Matching and an 
%   estimated Geometric Transformation using the matched Features

% Detect SURF Features
ptsOriginal  = detectSURFFeatures(original);
ptsDistorted = detectSURFFeatures(detected);

% Extract SURF Features
[featuresOriginal,validPtsOriginal] = extractFeatures(original,ptsOriginal);
[featuresDistorted,validPtsDistorted] = extractFeatures(detected,ptsDistorted);

% Find matching features (returns indices)
index_pairs = matchFeatures(featuresOriginal,featuresDistorted);

% Store Matched valid Points
matchedPtsOriginal  = validPtsOriginal(index_pairs(:,1));
matchedPtsDistorted = validPtsDistorted(index_pairs(:,2));

% Estimate geometric transform from matching point pairs
[tform,inlierPtsDistorted,inlierPtsOriginal] = estimateGeometricTransform(matchedPtsDistorted,matchedPtsOriginal,'similarity');

% Reference 2-D image to world coordinates
outputView = imref2d(size(original));

transformed_image = imwarp(detected,tform,'OutputView',outputView);
end

