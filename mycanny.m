function binarizedImage = mycanny(inputImage, T_Low, T_High,kSize,sigma)
    [x, y] = meshgrid(-floor(kSize/2):floor(kSize/2), -floor(kSize/2):floor(kSize/2));
    gaussianKernel = exp(-(x.^2 + y.^2) / (2 * sigma^2));
    gaussianKernel = gaussianKernel / sum(gaussianKernel(:));
        
    inputImage = double(imfilter(inputImage, gaussianKernel, 'conv'));

    B=[2,4,5,4,2;4,9,12,9,4;5,12,15,12,5;4,9,12,9,4;2,4,5,4,2];
    B= 1/159.*B;
    
    A1=conv2(inputImage,B, 'same');
    
    KGx=[-1 0 1; -2 0 2; -1 0 1];
    KGy=[-1 -2 -1; 0 0 0; 1 2 1];
    
    Filtered_X= conv2(A1,KGx, 'same');
    Filtered_Y= conv2(A1,KGy, 'same');
    
    arah=atan2 (Filtered_Y, Filtered_X);
    arah=arah.*180/pi;
    
    pan=size(A1,1);
    leb=size(A1,2);
    
    for i=1:pan
        for j=1:leb
            if(arah(i,j)<0)
                arah(i,j)=360+arah(i,j);
            end
        end
    end
    
    arah2=zeros(pan,leb);
    
    for i = 1:pan
        for j = 1:leb
            if ((arah(i, j) >= 0 && arah(i, j) < 22.5) || (arah(i, j) >= 157.5 && arah(i, j) < 202.5)||(arah(i, j) >= 337.5 && arah(i, j) <= 360))
                arah2(i, j) = 0;
            elseif ((arah(i, j) >= 22.5 && arah(i, j) < 67.5) || (arah(i, j) >= 202.5 && arah(i, j) < 247.5))
                arah2(i, j) = 45;
            elseif ((arah(i, j) >= 67.5 && arah(i, j) < 112.5) || (arah(i, j) >= 247.5 && arah(i, j) < 292.5))
                arah2(i, j) = 90;
            elseif ((arah(i, j) >= 112.5 && arah(i, j) < 157.5) || (arah(i, j) >= 292.5 && arah(i, j) < 337.5))
                arah2(i, j) = 135;
            end
        end
    end

    magnitude2 = sqrt(Filtered_X.^2 + Filtered_Y.^2);
    BW=zeros(pan,leb);
    
    for i=2:pan-1
        for j=2:leb-1
            if(arah2(i,j)==0)
                BW(i,j)=(magnitude2(i,j)==max([magnitude2(i,j),magnitude2(i,j+1),magnitude2(i,j-1)]));
            elseif(arah2(i,j)==45)
                BW(i,j)=(magnitude2(i,j)==max([magnitude2(i,j),magnitude2(i+1,j+1),magnitude2(i-1,j-1)]));
            elseif (arah2(i,j)==90)
                BW(i,j)=(magnitude2(i,j)==max([magnitude2(i,j),magnitude2(i+1,j),magnitude2(i-1,j)]));
            elseif(arah2(i,j)==135)
                BW(i,j)=(magnitude2(i,j)==max([magnitude2(i,j),magnitude2(i-1,j+1),magnitude2(i+1,j-1)]));
            end
        end
    end
    
    BW=BW.*magnitude2;

    T_Low = T_Low * max(BW(:));
    T_High = T_High * max(BW(:));
    T_res = zeros(pan, leb);
    
    for i = 1:pan
       for j = 1:leb
           if BW(i, j) < T_Low
               T_res(i, j) = 0;
           elseif BW(i, j) > T_High
               T_res(i, j) = 1;
           elseif BW(i+1, j) > T_High || BW(i-1, j) > T_High || ...
                  BW(i, j+1) > T_High || BW(i, j-1) > T_High || ...
                  BW(i-1, j-1) > T_High || BW(i+1, j+1) > T_High
               T_res(i, j) = 1;
          elseif BW(i+1, j) < T_Low || BW(i-1, j) < T_Low || ...
                  BW(i, j+1) < T_Low || BW(i, j-1) < T_Low || ...
                  BW(i-1, j-1) < T_Low || BW(i+1, j+1) < T_Low
               T_res(i, j) = 0;
           end
       end
    end

    binarizedImage=T_res.*255;
end
