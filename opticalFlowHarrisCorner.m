function opticalFlowHarrisCorner(img1, img2, dim)
image1 = imread(img1, 'tif');
image2 = imread(img2, 'tif');

image1 = im2double(image1);
image2 = im2double(image2);

[height, width] = size(image1);

image1_smoothen = zeros(height, width);
image2_smoothen = zeros(height, width);

dx1 = zeros(height, width);
dx2 = zeros(height, width);
dy1 = zeros(height, width);
dy2 = zeros(height, width);
sigma = 1;

kernelSize = 6*sigma +1;
k = 3;

kernelX = zeros(kernelSize, kernelSize);
kernelY = zeros(kernelSize, kernelSize);
kernel = zeros(kernelSize, kernelSize);

%x derivative
for i = 1:kernelSize
    for j = 1:kernelSize
        kernelX(i,j) = -((j-k-1)/(2*pi*sigma^3))*exp(-((i-k-1)^2+(j-k-1)^2)/(2*sigma^2));
    end
end

%y derivative
for i = 1:kernelSize
    for j = 1:kernelSize
        kernelY(i,j) = -((j-k-1)/(2*pi*sigma^3))*exp(-((i-k-1)^2+(j-k-1)^2)/(2*sigma^2));
    end
end


dx1 = filter2(kernelX, image1);
dy1 = filter2(kernelY, image1);
dx2 = filter2(kernelX, image2);
dy2 = filter2(kernelY, image2);

Ix = (dx1+dx2)/2;
Iy = (dy1+dy2)/2;

for i=1:kernelSize
    for j=1:kernelSize
        kernel(i,j) = (1/(2*pi*(sigma^2))) * exp(-((i-k-1)^2 + (j-k-1)^2)/(2*sigma));
    end
end

image1Smooth = filter2(kernel, image1);
image2Smooth = filter2(kernel, image2);
It = image1Smooth - image2Smooth;

neighborhoodN=5;

mat1=zeros(2,2);
mat2=zeros(2,2);

final1=zeros(height, width);
final2=zeros(height, width);

[r1,c1] = harrisCorner(img1);

length1 = length(r1);

for i=1:length1
    mat1=zeros(2,2);
    mat2=zeros(2,2);
    indexrow = r1(i);
    indexcol = c1(i);
    for m=indexrow-floor(neighborhoodN/2):indexrow+floor(neighborhoodN/2)
        for n=indexcol-floor(neighborhoodN/2):indexcol+floor(neighborhoodN/2)
            if((m >= (1+ floor(neighborhoodN/2))) && (m <= (height - floor(neighborhoodN/2)))...
                && (n >= (1 + floor(neighborhoodN/2))) && (n<= (width - floor(neighborhoodN/2))))
                
            mat1(1,1) = mat1(1,1) + Ix(m,n)*Ix(m,n);
            mat1(1,2) = mat1(1,2) + Ix(m,n)*Iy(m,n);
            mat1(2,1) = mat1(2,1) + Ix(m,n)*Iy(m,n);
            mat1(2,2) = mat1(2,2) + Iy(m,n)*Iy(m,n);
            mat2(1,1) = mat2(1,1) + Ix(m,n)*It(m,n);
            mat2(2,1) = mat2(2,1) + Iy(m,n)*It(m,n);
            end
        end
    end
    Ainv = pinv(mat1);
    result = Ainv*(-mat2);
    final1(indexrow, indexcol)=result(1,1);
    final2(indexrow, indexcol)=result(2,1);
end

final1 = flipud(final1);

final2 = flipud(final2);
subplot(2,3,dim+3);
imagesc(image1), axis image, colormap(gray), hold on
quiver(final1, final2, 15), title('optical flow');
end







    
    
















