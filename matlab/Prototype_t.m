 input = imread('input/img01.jpg');
 inputgray = rgb2gray(input);
 BW = imbinarize(inputgray,'adaptive','ForegroundPolarity','dark','Sensitivity',0.450);

 imshow(BW);

 edgedBW = edge(BW, 'canny', 0.9);
 figure();
 imshow(edgedBW);
 figure();
 edgedBWgrown = edgedBW;
 
 for i=1:size(edgedBW,2)
    for j=1:size(edgedBW,1)
        if(edgedBW(j,i)==1)
            edgedBWgrown(j-10:j+10,i-10:i+10) = 1;
        end
    end
 end
 imshow(edgedBWgrown);

 edgedBWgrownFilled = imfill(edgedBWgrown,'holes');
 figure();
 imshow(edgedBWgrownFilled);
  
   for i=1:size(edgedBWgrownFilled,2)
     for j=1:size(edgedBWgrownFilled,1)
         if(edgedBWgrownFilled(j,i)==0)
             input(j,i,:) = 0;
         end
     end
   end

 
  inputshrunk = input;
  
  for i=11:size(input,2)
     for j=11:size(input,1)
         if(input(j,i)==0)
             inputshrunk(j-10:j+10,i-10:i+10,:) = 0;
         end
     end
  end
  figure();
  imshow(inputshrunk);
  
 
%  
%  Ic=regionprops(logical(edgedBW),'BoundingBox');
%  
% rect2rng = @(pos,len)ceil(pos):(ceil(pos)+len-1);
% 
% for k = 1:numel(Ic)
%     rect = Ic(k).BoundingBox;
%     subImage = input(rect2rng(rect(2), rect(4)), rect2rng(rect(1), rect(3)));
%     fig = figure;
%     him = imshow(subImage);
%     title(sprintf('Bounding Box #%d', k)); 
% end