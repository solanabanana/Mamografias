
clc
clear all

filename = { 'M1.jpg', 'M2.jpeg', 'M3.jpeg', 'M4.jpg' ,'M6.jpeg', 'M7.jpg','M8.jpg', 'M9.jpg' ,'M10.jpg', 'M11.jpg' ,'B1.jpg' ,'B2.jpg', 'B4.jpg','B5.jpg' ,'B6.jpg', 'B7.jpg' ,'B8.jpg', 'B9.jpg', 'B10.png', 'B11.jpg'};
filename=filename';

for k = 1:20
    
    img = imread(filename{k}); 
    
    %segmentamos el tumor 
    tumor = TumorMama(filename{k});
    
    %determinamos si es maligno o benigno
    [R, X] = MalignoBenigno(tumor, img);  
    Xt(k,:)= X;
end  

Y = [1 1 1 1 1 1 1 1 1 1 0 0 0 0 0 0 0 0 0 0];

modelo = fitglm(Xt,Y,'Distribution', 'binomial', 'Link','logit');

%% 
filenameV = { 'M12.jpeg', 'M13.jpeg', 'M14.jpeg', 'M15.jpg' ,'M16.jpg', 'B12.jpg','B13.jpg'};

for k = 1:7
    
    imgV = imread(filenameV{k}); 
    
    %segmentamos el tumor 
    tumorV = TumorMama(filenameV{k});
    
    %determinamos si es maligno o benigno
    [R, X] = MalignoBenigno(tumorV, imgV);  
    Xv(k,:)= X;
end

y_pred = predict(modelo, Xv);

% accuracy = sum(y == (y_pred > 0.5)) / length(y);
% disp(['Accuracy: ', num2str(accuracy)]);
