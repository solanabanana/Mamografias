clc
clear all
%% Verificamos que la función MalignoBenigno esté clasificando bien
filenameN = {'N1.jpg','N2.jpg', 'N3.jpg', 'N4.jpg' ,'N5.jpg'};
for k = 1:5
    
    img = imread(filenameN{k}); 
    
    %Segmentamos el tumor 
    tumor = TumorMama(filenameN{k});
    
    %Obtenemos los parámetros de la masa
    [R, X] = MalignoBenigno(tumor, img);  
    Normales(k)= R;
end  
%% Obtenemos un modelo de regresión logística
%Utilizamos 10 imágenes de tumor malingo y 10 de benigno. Tomamos como
%parámetros los que nos deveulve la función MalignoBenigno
filename = {'M1.jpg','M2.jpeg', 'M3.jpeg', 'M4.jpg' ,'M6.jpeg', 'M7.jpg','M8.jpg', 'M9.jpg' ,'M10.jpg', 'M11.jpg' ,'B1.jpg' ,'B2.jpg', 'B4.jpg','B5.jpg','B6.jpg', 'B7.jpg' ,'B8.jpg', 'B9.jpg', 'B10.png', 'B11.jpg'};
filename=filename';

for k = 1:20
    
    img = imread(filename{k}); 
    
    %Segmentamos el tumor 
    tumor = TumorMama(filename{k});
    
    %Obtenemos los parámetros de la masa
    [R, X] = MalignoBenigno(tumor, img);  
    Xt(k,:)= X;
end  

Y = [1 1 1 1 1 1 1 1 1 1 0 0 0 0 0 0 0 0 0 0];

modelo = fitglm(Xt,Y,'Distribution', 'binomial', 'Link','logit')
%% Verificamos el funcionamiento de nuestro modelo
filenameV = { 'M12.jpeg', 'M13.jpeg', 'M14.jpg', 'M15.jpg' ,'M16.jpg', 'B12.jpg','B13.jpg', 'B14.png', 'B15.jpg', 'B16.jpg', 'B17.jpg'};

for k = 1:11
    
    imgV = imread(filenameV{k}); 
    
    %segmentamos el tumor 
    tumorV = TumorMama(filenameV{k});
    
    %determinamos si es maligno o benigno
    [R, X] = MalignoBenigno(tumorV, imgV);  
    Xv(k,:)= X;
end

y_pred = predict(modelo, Xv);
