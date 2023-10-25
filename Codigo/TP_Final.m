clc
clear all

filename= '2018_BC0021642_ MLO_L.jpg';
img = imread(filename); 

%segmentamos el tumor 
tumor = TumorMama(filename); 

figure(1)
subplot(121); 
imshow(img); 
title('Img Original'); 
subplot(122); 
imshow(tumor); 
title('Tumor Segmentado'); 

%determinamos si es maligno o benigno
R = MalignoBenigno(tumor, img);  
