function E = calculeazaEnergie(img)
%calculeaza energia la fiecare pixel pe baza gradientului
%input: img - imaginea initiala
%output: E - energia

%urmati urmatorii pasi:
%transformati imaginea in grayscale
%folositi un filtru sobel pentru a calcula gradientul in directia x si y
%calculati magnitudinea gradientului
%E - energia = gradientul imaginii

%completati aici codul vostru

% if size(img, 3)== 3
    img = rgb2gray(img);
% end

f = -fspecial ('sobel');
fX = imfilter (int16(img), f, 'replicate');
fY = imfilter (int16(img), f','replicate');
E = sqrt(double(fX.^2 + fY.^2));