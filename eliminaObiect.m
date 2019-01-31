function imgModificata = eliminaObiect(img, culoareDrum, ploteazaDrum, metodaSelectareDrum)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

figure, imshow(img);
rec = getrect; % iau coordonatele unui obiect ales de min, folosind cursorul

xmin = rec(1); % salveaza h si l ale obiectului respectiv
ymin = rec(2);
width = rec(3);
height = rec(4);

xmax = xmin + width;
ymax = ymin + height;

for i = 1:width
    
    disp(['Eliminam drumul vertical numarul ' num2str(i) ...
        ' dintr-un total de ' num2str(width)]);
    
    E = calculeazaEnergie(img); % calc energia imaginii obtinute
    E(ymin:ymax, xmin:xmax) = -10000; % aleg val aceasta ca sa treaca prin obiectul meu
    %alege drumul vertical care conecteaza sus de jos
    drum = selecteazaDrumVertical(E, metodaSelectareDrum);
    %afiseaza drum
    if ploteazaDrum
        ploteazaDrumVertical(img, E, drum, culoareDrum);
        pause(1);
        close(gcf);
    end
    %elimina drumul din imagine
    img = eliminaDrumVertical(img, drum);
end

for i = 1:height
    
    disp(['Eliminam drumul orizontal numarul ' num2str(i) ...
        ' dintr-un total de ' num2str(height)]);
    
    E = calculeazaEnergie(img); % calc energia imaginii obtinute
    E(xmin:xmax, ymin:ymax) = 10000; % aleg val aceasta ca sa treaca prin obiectul meu
    %alege drumul vertical care conecteaza sus de jos
    drum = selecteazaDrumVertical(E, metodaSelectareDrum);
    %afiseaza drum
    if ploteazaDrum
        ploteazaDrumVertical(img, E, drum, culoareDrum);
        pause(1);
        close(gcf);
    end
    %elimina drumul din imagine
    img = eliminaDrumVertical(img, drum);
end

imgModificata = img;



