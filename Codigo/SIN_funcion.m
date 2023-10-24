% TP PDI SIN FUNCION

filename='2018_BC0021981_ MLO_R.jpg';%FUNCIONA!
%filename='2018_BC0021642_ MLO_L.jpg';% FUNCIONA!
%filename='1506392319.jpeg';%FUNCIONA VER!!!
%filename='1507275789.jpeg';%FUNCIONA -> mm. toma 2 masas, puede tener 2 tumores?
%filename='1360800566.jpeg';% FUNCIONA

%filename='146978545.jpeg';%NO FUNCIONA 
 

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

umbral1=150;
umbral2=255;
img_out=imadjust(gris,[umbral1, umbral2]/255, [0, 255]/255);

figure()
imshow(img_out);

BW=imbinarize(img_out);

figure()
subplot(121)
imshow(BW)

%--------------------------
%ELIMINO BORDES 

[B,L]=bwboundaries(BW);

borde=size(L,2);

%cambiar 512 por tamano imagen!!


num=0;
max_inicio=max(L(:,11));
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

BW=imbinarize(L);

figure()
imshow(BW);
ylabel('binarizo sin bordes')

%---------------------
SE1=strel('square',2);
SE2=strel('disk',3);
SE3=strel('disk',15);
% 
% BW2=imerode(BW,SE1);
% BW2=imerode(BW2,SE1);
% BW2=imerode(BW2,SE2);
BW2=imdilate(BW,SE3);

figure()
subplot(121)
imshow(BW2)
ylabel('mascara con elementos')

mask=BW2;

%-> puede ser que haya otros elementos que me agarra
%los elimino (son de menor area que el del tumor)

L = bwlabel(mask);
% Medir el área de cada objeto
prop = regionprops(L, 'Area');
% Encontrar el índice del objeto más pequeño
areas = [prop.Area];
[~, indice_circulo_mas_pequeno] = min(areas);

% Eliminar el objeto más pequeño si hay mas de uno
if length(areas)>1
    mask(L == indice_circulo_mas_pequeno) = 0;
end


subplot(122)
imshow(mask);
ylabel('mascara final')

%------------
tumor=BW.*mask;

figure
imshow(tumor)
ylabel('tumor')


[B,L] = bwboundaries(tumor, 'noholes');
imshow(tumor); hold on;
colors='r';

if(size(B)>=1)
  boundary = B{1};
  plot(boundary(:,2), boundary(:,1),...
       'r','LineWidth',2);
end


