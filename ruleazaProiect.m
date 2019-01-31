%proiect REALIZAREA DE MOZAICURI
%

%%
%seteaza parametri pentru functie

%citeste imaginea care va fi transformata in mozaic
%puteti inlocui numele imaginii
params.imgReferinta = imread('../data/imaginiTest/ferrari.jpeg');


%seteaza directorul cu imaginile folosite la realizarea mozaicului
%puteti inlocui numele directorului
params.numeDirector = '../data/colectie';

params.tipImagine = 'png';

%seteaza numarul de piese ale mozaicului pe orizontala
%puteti inlocui aceasta valoare
params.numarPieseMozaicOrizontala = 100;
%numarul de piese ale mozaicului pe verticala va fi dedus automat

%seteaza optiunea de afisare a pieselor mozaicului dupa citirea lor din
%director
params.afiseazaPieseMozaic = 0; % pt a imi afisa mozaicul, pun valoarea 1


%seteaza modul de aranjare a pieselor mozaicului
%optiuni: 'aleator','aleator'
params.modAranjare = 'caroiaj';
%params.modAranjare = 'aleator';

%seteaza criteriul dupa care realizeze mozaicul
%optiuni: 'aleator','distantaCuloareMedie'
params.criteriu = 'distantaCuloareMedie';
%params.criteriu = 'aleator';


%%
%apeleaza functia principala
imgMozaic = construiesteMozaic(params);
figure, imshow(imgMozaic)
% imwrite(imgMozaic,'mozaic.jpg');
% figure, imshow(imgMozaic)

imwrite(imgMozaic,'mozaic.jpg', 'jpg');
