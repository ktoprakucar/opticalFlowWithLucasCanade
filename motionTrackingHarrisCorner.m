tic;

img1 = 'img1.tif';
img2 = 'img2.tif';

for i = 1:3
    image1 = gaussianPyramidHarrisCorner(img1, i);
    image2 = gaussianPyramidHarrisCorner(img2, i);
    opticalFlowHarrisCorner(image1, image2, i);   
end

TimeSpent = toc;