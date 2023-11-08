

function [resultado, X] = MalignoBenigno(tumor, ImgOrg)

%calculamos los diferentes parametros para detereminar si es o no 
%una masa maligna

%% verifico si se encontraron tumores 
tumor_neg = sum(tumor(:)); 

if tumor_neg == 0 %no hay tumor para analizar
    resultado = 'N';
end

gray = ismatrix(ImgOrg);
gris=ImgOrg;

if gray == false %no esta en escala de grises
    gris = rgb2gray(ImgOrg);
end

%% calculamos los parametros

tumorR=double(gris).*tumor;
tumorR=uint8(tumorR);

vector=uint8(tumorR(:));
vectord=double(tumorR(:));

m = mean(tumorR(:));
de = std2(vector);
k = kurtosis(vectord);

tumorBW = imbinarize(tumorR);
% Calcular propiedades de la forma (área y perímetro) con regionprops
propiedades = regionprops(tumorBW, 'Area', 'Perimeter');
area = propiedades.Area;
perimetro = propiedades.Perimeter;

% Calcular el ENC
ENC = (2 * sqrt(pi * area))/perimetro;

% Calculamos la entropia del histograma
imgH=imhist(tumorR);
SK = skewness(imgH);

% Calcular el gradiente de la imagen
[dx, dy] = gradient(double(tumorR));
% Calcular la magnitud del gradiente
magnitud_gradiente = sqrt(dx.^2 + dy.^2);
% Calcular la varianza de la magnitud del gradiente para medir la suavidad
SM = var(magnitud_gradiente(:));

if de>=7 && de<=15.5
    resultado='M';
elseif de>15.5 && k<100
    resultado='M';
elseif de<7 && k>2000
    resultado='M';
else
    resultado='B';
end


X = [m de k area perimetro ENC SK];

end

