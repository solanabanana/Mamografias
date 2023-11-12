function tumor = TumorMama(filename)

%Leemos imagen
img=imread(filename);

%Sino está en escala de grises, la modifico para que lo esté
gray = ismatrix(img);
gris=img;
if gray == false %no esta en escala de grises
    gris = rgb2gray(img);
end



%Determinamos un umbral en función del histograma ecualizado
%Modificamos la imagen en función del umbral
J=histeq(gris);
umbral1=150;
umbral2=255;

img_out=imadjust(gris,[umbral1, umbral2]/255, [0, 255]/255);

%Binarizamos la imagen
BW=imbinarize(img_out);

%Creamos un elemento estructurante con el que vamos a realizar operaciones
%morfológicas sobre la mamografía
se=strel('disk',7);
BW=imclose(BW,se);

%% ELIMINO BORDES 

[B,L]=bwboundaries(BW);

borde=size(L,2); %Nos quedamos con la altura de la matriz de etiquetas

%Obtengo índices de donde empieza y termina la matriz de etiquetas
num=0;
max_inicio=max(L(:,1));
max_final=max(L(:,borde));

%Si se encuentra un elemento en el borde, es ruido, lo eliminamos
for i=1:max_inicio
    fila_inicio=find(L(:,1)==i);

    if ~isempty(fila_inicio)
        distinta_cero1 = fila_inicio(1);
        num1=L(distinta_cero1,1);
        L(L==num1)=0;
    end
end

%Lo mismo hacemos para el otro borde
for i=1:max_final
     fila_final=find(L(:,borde)==i);

    if ~isempty(fila_final)
        distinta_cero2 = fila_final(1);
        num2=L(distinta_cero2,borde);
        L(L==num2)=0;
    end
end
%%

%Binarizamos la matriz de etiquetas
BWL=imbinarize(L);

%Creamos un elemento estructurante con el que vamos a realizar operaciones
%morfológicas sobre la mamografía
%---------------------
SE1=strel('square',5);
SE2=strel('disk',3);
SE3=strel('disk',10);
% 

%TUVE QUE EROSIONAR PARA SACAR RUIDO! Dilatamos para agrandar y suavizar 
%los elementos que se encuentran en la imagen
BW2=imerode(BWL,SE1);
BW2=imdilate(BW2,SE3);

mask=BW2;


% Le sacamos el área, el perímetro y el centroide de cada elemento presente
L1 = bwlabel(mask);
prop = regionprops(L1, 'Area', 'Perimeter', 'Centroid');
areas = [prop.Area];
perimeters = [prop.Perimeter];

%Calculamos el factor de redondez
for k = 1:length(prop)
    r = perimeters(k)/(2*pi) + 0.5;
    FR(k) = (4*pi*areas(k))/(perimeters(k)^2)*(1 - 0.5/r)^2;
end

%Si el FR es menor a 0.55 determinamos que no es un tumor ni una masa que 
%nos interese, la eliminamos de la imagen
for i=1:length(prop)
    if FR(i) < 0.55
       mask(L1 == i) = 0;
    end
end

%%Saco matriz de etiquetas y area de los elementos de la mascara modificada
L2 = bwlabel(mask);
prop2 = regionprops(mask, 'Area');
areas2 = [prop2.Area];

%Obtengo el indice del elemento de mayor area
[valor_max, indice_circulo_mas_grande] = max(areas2);

%Si hay más de un elemento de la máscara, elimino el más grande que es un
%borde o algo detectado que no es un tumor
if length(areas2)>1
   for i=1:length(areas2)
       mask(L2 ~= indice_circulo_mas_grande) = 0;
   end
end

% Segmentamos la zona del tumor
tumor=BW.*mask;

%Obtenemos bordes y matriz de etiquetas de la zona dilatada del tumor
[B3,L3] = bwboundaries(tumor);

%Obtenemos los elementos dentro de la zona dilatada del tumor
prop3 = regionprops(L3, 'Area');
areas3 = [prop3.Area];
[valor_max, indice_circulo_mas_grande3] = max(areas3);

% Eliminar los objetos pequeÃ±os si hay mas de un objeto en la imagen
if length(areas3)>1
   for i=1:length(areas3)
       tumor(L3 ~= indice_circulo_mas_grande3) = 0;
   end
end
end
