function  [newim] = geotransform2(im, T)
%    im = rgb2gray(im);
%    im = double(im/255);
    [rows, cols] = size(im);
    x = (1:cols)';
    y = (1:rows)';

    [xi, yi] = meshgrid(x,y);
    xi_size = length(xi(:));
    imgT = T \ [xi(:) yi(:) ones(xi_size, 1)]';

    x = imgT(1,:) ./ imgT(3,:);
    y = imgT(2,:) ./ imgT(3,:);

    newim = interp2(im, x, y);
    newim = reshape(newim, rows, cols);
end