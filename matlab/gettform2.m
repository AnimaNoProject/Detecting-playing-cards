% 	Erzeugung einer Transformationsmatrix mittels 
% 	Direct Linear Transformation (DLT)
%   Parameter:
%       mov - 2x4 Matrix, Zielkoordinaten
%       fix - 2x4 Matrix, Ecken einer Karte
%   Ausgabe:
%       H - 3x3 Matrix
%   Aleksandar Marinkovic

function H = gettform2(mov,fix)
    
    npts=4;         % Anzahl der Punkte
    
    % Koordinaten des Ziels
    x = mov(1,:);    
    y = mov(2,:); 
    % Koordinaten der Eckpunkte
    xd = fix(1,:);
    yd = fix(2,:);
    
    % 8x9 Matrix mittels DLT bilden
    H = zeros(2*npts,9);
    for i=1:npts
        H(2*i-1,:) = [x(i) y(i) 1 0 0 0 -xd(i).*x(i) -xd(i).*y(i) -xd(i)];
        H(2*i,:)   = [0 0 0 x(i) y(i) 1 -yd(i).*x(i) -yd(i).*y(i) -yd(i)]; 
    end
    
    % Transformationsmatrix aus V entnehmen
    [U,S,V] = svd(H); % H = U*S*V
    H=reshape(V(:,9),3,3)';
    
    % Normalisieren
    S = svd(H);
    H = H / S(2);
end