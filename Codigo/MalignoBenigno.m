function resultado = MalignoBenigno(tumor, ImgOrg)

%calculamos los diferentes parametros para detereminar si es o no 
%una masa maligna

%% verifico si se encontraron tumores 
tumor_neg = sum(tumor(:)); 

if tumor_neg == 0 %no hay tumor para analizar
    resultado = 'N';
end

%% tenemos que aplicar la mascara a la imagen original 
% para quedarnos con el segmento del tumor en esacala de grises

% el analisis lo tenemos que hacer sobre la escala de grises!
I = rgb2gray(ImgOrg);
%aplico la mascara a la imagen origI = rgb2gray(ImgOrg);
Tfinal = double(I).*tumor;
Tfinal = uint8(Tfinal);

% los parametros se calculan sobre las intensidades del histograma
% calculamos el histograma
[counts,binLocations] = imhist(Tfinal);

%% desviacion estandar DE
% es alta comparada con masas beningnas -> DE>80
DE = std2(Tfinal(Tfinal>0));

%% Suavidad S
% es alta para masas sospechosas -> S >0.10
% -> VERRRR ???

%% Asimetria A
% es negativa para las masas sopechosas
A = skewness(double(Tfinal(:)));

%% Curtosis C
% es alto para las masas sopechosas -> K>1000
C = kurtosis(Tfinal(:));


%%
if DE >8 && A<1 && C>1000
    resultado = 'M';
else 
    resultado = 'B';
end

end
