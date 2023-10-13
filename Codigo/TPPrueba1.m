img = imread('2018_BC0021981_ CC_R.jpg');
img = rgb2gray(img);
figure(1)
imshow(img);
imcontrast;

umbrales = multithresh(img, 2);
img_out = imadjust(img, [92, 114]/255, [0, 255]/255);
figure(2);
imshow(img_out);