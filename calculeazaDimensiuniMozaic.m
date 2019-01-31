function params = calculeazaDimensiuniMozaic(params)
%calculeaza dimensiunile mozaicului
%obtine si imaginea de referinta redimensionata avand aceleasi dimensiuni
%ca mozaicul

%completati codul Matlab
[H, W, C] = size (params.imgReferinta)
[h, w, c] = size (params.pieseMozaic(:, :, :, 1));
x = (H*w*params.numarPieseMozaicOrizontala)/(W*h) %";" nu afieaza var x 


%calculeaza automat numarul de piese pe verticala
params.numarPieseMozaicVerticala = round(x);

%calculeaza si imaginea de referinta redimensionata avand aceleasi dimensiuni ca mozaicul
params.imgReferintaRedimensionata = imresize(params.imgReferinta, [ params.numarPieseMozaicVerticala*h params.numarPieseMozaicOrizontala*w]); %pot pune si ",", in loc de " ", tre ca matrice
