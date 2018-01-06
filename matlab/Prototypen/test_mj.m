o = ones(100,100);
z = zeros(100,100);
m = [z,o,o,z;
    o,z,z,o;
    z,o,o,z;
    o,z,z,o];

figure();
%imshow(m);

m1 = m(:,1:200);
m2 = m(:,201:end);

%subplot(1,3,1), imshow(m);
%subplot(1,3,2), imshow(m1);
%subplot(1,3,3), imshow(m2);

r1 = imrotate(m,45);
r2 = rot90(m,1);

subplot(1,3,1), imshow(m);
subplot(1,3,2), imshow(r1);
subplot(1,3,3), imshow(r2);
