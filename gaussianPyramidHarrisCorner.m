function imgname = gaussianPyramidHarrisCorner(img, reductionfactor)

I = imread(img, 'tif');
ReducedI = I;
sizeI = size(I);
sigma = 2;
k = fspecial('gaussian', fix(6*sigma), sigma);
ReductionFactor = reductionfactor;
for t=1:1:ReductionFactor
    FinalI = ReducedI;
    if t==1 FinalI = filter2(k,ReducedI)/255; 
    else FinalI = filter2(k, ReducedI);
    end
    
    %reduced image size computation
    sizeI(1) = floor(sizeI(1)/2);
    sizeI(2) = floor(sizeI(2)/2);
    
    %create the reduced image through sampling
    ReducedI = zeros(sizeI(1), sizeI(2));
    for i = 1:1:sizeI(1)
        for j=1:1:sizeI(2)
            ReducedI(i,j) = FinalI(i*2, j*2);
        end
    end
end

imgname = [img '_' int2str(reductionfactor)];
imwrite(ReducedI, imgname, 'tif');
end
    
    
    