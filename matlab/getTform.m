function [tform] = getTform(movPts, fixPts)
    [movPts,normMatrix1] = images.geotrans.internal.normalizeControlPoints(movPts);
    [fixPts,normMatrix2] = images.geotrans.internal.normalizeControlPoints(fixPts);

    M = size(fixPts,1);
    % Koordinaten der Ecken
    u = movPts(:,1);
    v = movPts(:,2);
    % Koordinaten der Fixpuntke
    x = fixPts(:,1);
    y = fixPts(:,2);
    vec_1 = ones(M,1);
    vec_0 = zeros(M,1);

    % U = X * Tvec, where Tvec = [A B C D E F G H]' ... homogene Matrix
    U = [u; v];
    % u = [x y 1 0 0 0 -ux -uy] * [A B C D E F G H]'
    % v = [0 0 0 x y 1 -vx -vy] * [A B C D E F G H]'
    X = [x      y       vec_1   vec_0   vec_0   vec_0   -u.*x    -u.*y;
         vec_0  vec_0   vec_0   x       y       vec_1   -v.*x    -v.*y];
    % Lösen des linearen Gleichungssytem
    Tvec = mldivide(X,U);
    Tvec(9) = 1;
    Tinv = reshape(Tvec,3,3);
    % Lösen des linearen Gleichungssytem
    Tinv = mldivide(normMatrix2,(Tinv * normMatrix1));
    T = inv(Tinv);
    T = T ./ T(3,3);
    % creates a TFORM struct for an N-dimensional projective transformation
    tform = maketform('projective',T); %projective2d(T);
end