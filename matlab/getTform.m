function H = gettform(mov,fix)
    % Punkte normalisieren
    [mov, T1] = normalise2dpts(mov);
    [fix, T2] = normalise2dpts(fix);
  
    dim = length(mov);
    A = zeros(3*dim,9);
    
    % homogene Transformationsmatrix mittels DLT Algorithmus
    for n = 1:dim
        M = mov(:,n)';
        x = fix(1,n); 
        y = fix(2,n); 
        w = fix(3,n);
        A(3*n-2,:) = [0 0 0  -w*M     y*M];
        A(3*n-1,:) = [w*M    0 0 0   -x*M];
    	A(3*n  ,:) = [-y*M    x*M   0 0 0];
    end
    
    [U,S,V] = svd(A); % A = U*S*V, V --> homogene Matrix
    
    % 3x3 Matrix 
    H = reshape(V(:,9),3,3)';
    
    % Denormalisieren
    H = T2\H*T1;
end

function [newpts, T] = normalise2dpts(pts)
    s = mean(pts(1:2,:)')';      
    % Verschiebe xy um s
    newp(1,:) = pts(1,:)-s(1);    
    newp(2,:) = pts(2,:)-s(2);
    
    dist = hypot(newp(1,:), newp(2,:));
    meandist = mean(dist(:));
    
    scale = sqrt(2)/meandist;
    
    T = [scale   0   -scale*s(1)
         0     scale -scale*s(2)
         0       0      1      ];
    
    newpts = T*pts;
end