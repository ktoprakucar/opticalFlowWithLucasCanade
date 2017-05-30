function [r,c] = harrisCorner(imgName)

I = imread(imgName, 'tif');

Gx = [1 0 -1; 1 0 -1;1 0 -1];
Gy = Gx';
Ix = conv2(double(I), double(Gx));
Iy = conv2(double(I), double(Gy));
sigma = 2;
gauss = fspecial('gaussian', fix(6*sigma),sigma);

Ix2 = conv2(Ix.^2, gauss);
Iy2 = conv2(Iy.^2, gauss);
Ixy = conv2(Ix.*Iy, gauss);

cornerness = (Ix2.*Iy2 - Ixy.^2)./(Ix2 + Iy2 + eps);

size = 5;
max = ordfilt2(cornerness, size^2, ones(size));
thres = 1000;
cornerness = (cornerness==max)&(cornerness > thres);
[r,c] = find(cornerness);


end