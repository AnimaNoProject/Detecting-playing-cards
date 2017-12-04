function maxcorr = tmc( target, template)
%TMC Summary of this function goes here
%   Detailed explanation goes here

    A = target(:,:,1);
    B = template(:,:,1);

    corr_map = zeros([size(A,1),size(A,2)]);

    for i = 1:size(A,1)-size(B,1)
        for j = 1:size(A,2)-size(B,2)
            %Construct the correlation map
            corr_map(i,j) = corr2(A(i:i+size(B,1)-1,j:j+size(B,2)-1),B);
        end
    end

    %Find the maximum value
    maxpt = max(corr_map(:));
    maxcorr= maxpt;
    [x,y]=find(corr_map==maxpt);

    %Display the image from the template
    figure,imagesc(template);title('Template Image');colormap(gray);axis image

    grayA = rgb2gray(target);
    Res   = A;
    Res(:,:,1)=grayA;
    Res(:,:,2)=grayA;
    Res(:,:,3)=grayA;

    Res(x:x+size(B,1)-1,y:y+size(B,2)-1,:)=target(x:x+size(B,1)-1,y:y+size(B,2)-1,:);

    figure,imagesc(Res);title('Matched');
end

