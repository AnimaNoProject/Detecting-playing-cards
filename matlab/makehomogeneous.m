function hx = makehomogeneous(x)
    [rows, npts] = size(x);
    hx = ones(rows+1, npts);
    hx(1:rows,:) = x;
end