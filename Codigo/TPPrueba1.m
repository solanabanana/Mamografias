img = imread('2018_BC0021981_ CC_R.jpg');

gray = ismatrix(img);
if gray == false %no esta en escala de grises
    img = rgb2gray(img);
end

figure(1)
imshow(img);
% imcontrast;

T = adaptthresh(img, 0.4);
BW = imbinarize(img, T);

[B, L] = bwboundaries(BW, 'noholes');
stats = regionprops(BW, 'Area','Image');
[area_max, i_max] = max([stats.Area]);
imagen = stats(i_max).Image;

% img_out = imadjust(img, [92, 114]/255, [0, 255]/255);
figure(2);
colors=['b' 'g' 'r' 'c' 'm' 'y'];
imshow(BW);
hold on;
boundary = B{i_max};
cidx = mod(k,length(colors))+1;
  plot(boundary(:,2), boundary(:,1),...
       colors(cidx),'LineWidth',2);

SE2 = strel('square', 4);
SE3 = strel('disk', 4);
SE4 = strel('disk', 7);
SE5 = strel('disk', 10);

BW1 = imerode(imagen, SE2); 
BW1 = imerode(BW1, SE2); 
BW1 = imerode(BW1, SE2); 
BW1 = imclose(BW1, SE3); 
BW1 = imopen(BW1, SE4);
BW1 = imdilate(BW1, SE5);

figure(3)
imshowpair(imagen, BW1, 'montage');
