function [ result ] = plotbox(Target, Template, M)
%PLOTBOX Summary of this function goes here
%   Detailed explanation goes here
    [r1,c1]=size(Target);
    [r2,c2]=size(Template);

    [r,c]=max(M);
    [r3,c3]=max(max(M));

    i=c(c3);
    j=c3;
    result=Target;
    for x=i:i+r2-1
       for y=j
           result(x:x+5,y:y+5)=255;
       end
    end
    for x=i:i+r2-1
       for y=j+c2-1
           result(x:x+5,y:y+5)=255;
       end
    end
    for x=i
       for y=j:j+c2-1
           result(x:x+5,y:y+5)=255;
       end
    end
    for x=i+r2-1
       for y=j:j+c2-1
           result(x:x+5,y:y+5)=255;
       end
    end
end

