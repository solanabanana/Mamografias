function [resultado, X] = MalignoBenigno(tumor, ImgOrg)

%Determinamos si se encontró una masa o no y si esa masa es sospechosa o no

%% Verificamos si se encontraron tumores 
tumor_neg = sum(tumor(:)); 

if tumor_neg == 0 %no hay tumor para analizar
    resultado = 'N';
end

gray = ismatrix(ImgOrg);
gris=ImgOrg;

if gray == false %no esta en escala de grises
    gris = rgb2gray(ImgOrg);
end
%% Calculamos parámetros de la masa

%Obtenemos la masa en su escala de grises original
tumorR=double(gris).*tumor;
tumorR=uint8(tumorR);

% La vectorizamos
vector=uint8(tumorR(:));
vectord=double(tumorR(:));

%Caclulamos la media
m = mean(tumorR(:));

%Calculamos el desvío estandar
de = std2(vector);

%Calculamos la curtosis
k = kurtosis(vectord);

%Binarizamos el tumor
tumorBW = imbinarize(tumorR);

% Calculamos el perímetro y el área del mismo
propiedades = regionprops(tumorBW,'Area', 'Perimeter');
perimetro = propiedades.Perimeter;
area = propiedades.Area;

% Calculamos el ENC
ENC = (2 * sqrt(pi * area))/perimetro;

if m<0.08
    resultado='N';
else
    resultado='T';
end

X = [de k m ENC perimetro];
end
