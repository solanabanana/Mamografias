% TP PDI SIN FUNCION

close all
clear


%%FUNCIONAN:
%filename='2018_BC0021642_ MLO_L.jpg';% FUNCIONA CON ESTE CODIGO TAMB. ENC=0.44
%filename='1506392319.jpeg';% FUNCIONA CON ESTE CODIGO TAMB. ENC=0.63
%filename='Maligno2.jpeg';% FUNCIONA
%filename='Maligno3.jpeg';%ENC=0.93
%filename='Maligno4.jpg'; %ENC=0.89
filename='Maligno6.jpeg';% FUNCIONA

%filename='Maligno7.jpg';%NO SE SI ES EL TUMOR REALMENTE!

%filename='Maligno8.jpg';% FUNCIONA
%filename='Maligno11.jpg';%F
%filename='Maligno12.jpg';%F, comentar restriccion area!
%filename='Maligno14.jpg';


%filename='Benigno1.jpg';% 1era de github. ENC=0.82
%filename='Benigno2.jpg';%FUNCIONA. ENC=0.62
%filename='Benigno4.jpg';%FUNCIONA
%filename='Benigno6.jpg';%F
%filename='Benigno7.jpg';%F
%filename='Benigno8.jpg';%F

%TOTAL: 6B, 10M, 1M que no se si esta bien segm 

%%
%MAL SEGMENTADAS:
%filename='1507275789.jpeg';% FUNCIONA. ENC=0.53 SEGMENTA MAL!
%filename='1360800566.jpeg';%NO FUNCIONA. (antes si funcionaba :()
%filename='Maligno5.jpeg';% NO FUNCIONA
%filename='Maligno10.jpg';%no segmenta bien
%filename='Benigno3.jpg';%RARIII
%filename='Benigno9.jpg';%de=11, k=269, ni yo identifico el tumor.

%MAL IDENTIFICADAS:
%filename='Maligno9.jpg'; 
%filename='Benigno5.jpg';%de=8.52, k=430

%NI IDEA PROBLEMA
% filename='146978545.jpeg';%NO FUNCIONA 
% filename='Maligno3.jpg';% NO FUNCIONA PERO SI BORRAS MAS EL BORDE CREO Q VA A FUNCIONAR
% filename='Maligno1.jpeg';% NO FUNCIONA

% filename='1524699538.jpeg';% NO FUNCIONA
% filename='1223615557.jpeg';% NO FUNCIONA
% filename='1203336509.jpeg';% NO FUNCIONA
% filename='155909056.jpeg';% NO FUNCIONA


img=imread(filename);


gray = ismatrix(img);
gris=img;
if gray == false %no esta en escala de grises
    gris = rgb2gray(img);
end


figure(1)
subplot(121)
imshow(img);

J=histeq(gris);
subplot(122)
imshow(J)
%imcontrast;
impixelinfo;
%para benigno 1 tuve que cortar imagen!


umbral1=150;
umbral2=255;
img_out=imadjust(gris,[umbral1, umbral2]/255, [0, 255]/255);


figure(2)
imshow(img_out);

BW=imbinarize(img_out);

se=strel('disk',7);
BW=imclose(BW,se);

figure(3)
subplot(121)
imshow(BW)

%--------------------------
%ELIMINO BORDES 

[B,L]=bwboundaries(BW);

borde=size(L,2); %Nos quedamos con la altura de la matriz de etiquetas


num=0;
max_inicio=max(L(:,1));
max_final=max(L(:,borde));

for i=1:max_inicio
    fila_inicio=find(L(:,1)==i);

    if ~isempty(fila_inicio)
        distinta_cero1 = fila_inicio(1);
        num1=L(distinta_cero1,1);
        L(L==num1)=0;
    end
end

%pongo solo un num porque solo aparecen elementos en uno de los dos bordes

for i=1:max_final
     fila_final=find(L(:,borde)==i);

    if ~isempty(fila_final)
        distinta_cero2 = fila_final(1);
        num2=L(distinta_cero2,borde);
        L(L==num2)=0;
    end
end


% Visualizar la imagen resultante
subplot(122)
imshow(L);
ylabel('bordes sin elementos')

BWL=imbinarize(L);

figure(4)
subplot(121)
imshow(BWL);
ylabel('binarizo sin bordes')

%---------------------
SE1=strel('square',5);
SE2=strel('disk',3);
SE3=strel('disk',10);
% 

%TUVE QUE EROSIONAR PARA SACAR RUIDO!
BW2=imerode(BWL,SE1);
subplot(122)
imshow(BW2)
ylabel('erosiono')
% BW2=imerode(BW2,SE1);
% BW2=imerode(BW2,SE2);
BW2=imdilate(BW2,SE3);
%BW2=imdilate(BW2,SE3);



figure(5)
subplot(131)
imshow(BW2)
ylabel('mascara dilatada')

mask=BW2;
hold on;
%-> puede ser que haya otros elementos que me agarra
%los elimino (son de menor area que el del tumor)

[Lq, B1] = bwboundaries(mask);
L1 = bwlabel(mask);
% Medir el área de cada objeto
prop = regionprops(L1, 'Area', 'Perimeter', 'Centroid');
% Encontrar el índice del objeto más pequeño
areas = [prop.Area];
perimeters = [prop.Perimeter];

for k = 1:length(prop)
    r = perimeters(k)/(2*pi) + 0.5;
    FR(k) = (4*pi*areas(k))/(perimeters(k)^2)*(1 - 0.5/r)^2;
end

for k = 1:length(FR)
    circ_string = sprintf('%2.2f',FR(k));
    circulo = B{k};
    centroid = prop(k).Centroid;
    text(centroid(1), centroid(2), circ_string, ...
        'Color', 'red', 'FontSize', 10, 'HorizontalAlignment', 'center');
end

% for i=1:length(prop)
%     if FR(i) < 0.55
%        mask(L1 == i) = 0;
%     end
% end

L2 = bwlabel(mask);
prop2 = regionprops(mask, 'Area');
areas2 = [prop2.Area];
[valor_max, indice_circulo_mas_grande] = max(areas2);
subplot(132)
imshow(mask);
ylabel('mascara semi')
% Eliminar los objetos pequeños si hay mas de un objeto en la imagen
if length(areas2)>1
   for i=1:length(areas2)
       mask(L2 ~= indice_circulo_mas_grande) = 0;
   end
end


% Podemos hacer un while, quedarse con el indice del maximo y ir borrando
% los mas chicos a este

subplot(133)
imshow(mask);
ylabel('mascara final')

%------------
tumor=BW.*mask;

figure(6)
[B3,L3] = bwboundaries(tumor);

prop3 = regionprops(L3, 'Area');
areas3 = [prop3.Area];
[valor_max, indice_circulo_mas_grande3] = max(areas3);

% Eliminar los objetos pequeños si hay mas de un objeto en la imagen
if length(areas3)>1
   for i=1:length(areas3)
       tumor(L3 ~= indice_circulo_mas_grande3) = 0;
   end
end


[B4,L4] = bwboundaries(tumor);

imshow(tumor)
ylabel('tumor'); hold on;
colors='r';


if(size(B4)>=1)
  boundary = B4{1};
  plot(boundary(:,2), boundary(:,1),...
       'r','LineWidth',2);
end

figure(7)
subplot(121)
imshow(img);
subplot(122)
imshow(tumor);

%------------------------------------------------
%MALIGNO vs BENIGNO

%% verifico si se encontraron tumores 
tumor_neg = sum(tumor(:)); 

if tumor_neg == 0 %no hay tumor para analizar
    resultado = 'N';
end

tumorR=double(gris).*tumor;
tumorR=uint8(tumorR);

vector=uint8(tumorR(:));
vectord=double(tumorR(:));

de=std2(vector);
k = kurtosis(vectord);


if de>=7 && de<=15.5
    resultado='M';
elseif de>15.5 && k<100
    resultado='M';
elseif de<7 && k>2000
    resultado='M';
else
    resultado='B';
end 

        
figure()
subplot(121)
imshow(gris)
ylabel('Imagen original')
subplot(122)
imshow(tumorR)
ylabel('Tumor')
if resultado=='B'
    title('Tumor benigno');
end
if resultado=='M'
    title('Tumor maligno');
end


%glcm = graycomatrix(tumor, 'NumLevels', 256, 'Offset', [0 1; -1 1; -1 0; -1 -1]);
% Calcular propiedades de la GLCM
%propiedades_glcm = graycoprops(glcm, {'Contrast', 'Energy'});



%------------------------------------------------
%MALIGNO vs BENIGNO

%% verifico si se encontraron tumores 
tumor_neg = sum(tumor(:)); 

if tumor_neg == 0 %no hay tumor para analizar
    resultado = 'N';
end

%% tenemos que aplicar la mascara a la imagen original 
% para quedarnos con el segmento del tumor en esacala de grises

% el analisis lo tenemos que hacer sobre la escala de grises!
ImgOrg=imread(filename);
gray = ismatrix(ImgOrg);
I=ImgOrg;
if gray == false %no esta en escala de grises
    I = rgb2gray(ImgOrg);
end
%I = rgb2gray(ImgOrg);

%aplico la mascara a la imagen origI = rgb2gray(ImgOrg);
Tfinal = double(I).*tumor;
Tfinal = uint8(Tfinal);

% Calcular propiedades de la forma (�rea y per�metro) con regionprops
propiedades = regionprops(tumor, 'Area', 'Perimeter');
area = propiedades.Area;
perimetro = propiedades.Perimeter;

% Calcular el ENC
ENC = (2 * sqrt(pi * area)) / perimetro;






