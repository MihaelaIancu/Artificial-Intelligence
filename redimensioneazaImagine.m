function imgRedimensionata = redimensioneazaImagine(img,parametri)
%redimensioneaza imaginea
%
%input: img - imaginea initiala
%       parametri - stuctura de defineste modul in care face redimensionarea 
%
% output: imgRedimensionata - imaginea redimensionata obtinuta


optiuneRedimensionare = parametri.optiuneRedimensionare;
metodaSelectareDrum = parametri.metodaSelectareDrum;
ploteazaDrum = parametri.ploteazaDrum;
culoareDrum = parametri.culoareDrum;

switch optiuneRedimensionare
    
    case 'micsoreazaLatime'
        numarPixeliLatime = parametri.numarPixeliLatime;
        imgRedimensionata = micsoreazaLatime(img,numarPixeliLatime,metodaSelectareDrum,...
                            ploteazaDrum,culoareDrum);
        
    case 'miscoreazaInaltime'
        %completati aici codul vostru
        
        numarPixeliLatime = parametri.numarPixeliLatime;
        img = imrotate(img, 90);
        imgRedimensionata = micsoreazaLatime(img,numarPixeliLatime,metodaSelectareDrum,...
                            ploteazaDrum,culoareDrum);
        imgRedimensionata = imrotate(imgRedimensionata, -90);
        
        
    case 'maresteLatime'
        %completati aici codul vostru
        
        numarPixeliLatime = parametri.numarPixeliLatime;
        imgRedimensionata = maresteLatime(img,numarPixeliLatime,metodaSelectareDrum,...
                            ploteazaDrum,culoareDrum);
        
    case 'maresteInaltime'
        %completati aici codul vostru
        
        numarPixeliLatime = parametri.numarPixeliLatime;
        img = imrotate(img, -90);
        imgRedimensionata = maresteLatime(img,numarPixeliLatime,metodaSelectareDrum,...
                            ploteazaDrum,culoareDrum);
        imgRedimensionata = imrotate(imgRedimensionata, 90);
        
    
    case 'amplificaContinut'
        %completati aici codul vostru
        
        imgl = imresize(img, 2);
        [H, L, ~] = size(img);
        [h, l, ~] = size(imgl);
        numarPixeliLatime = l-L;
        numarPixeliInaltime = h-H;
        imgRedimensionata = micsoreazaLatime(...
            imgl, numarPixeliLatime, metodaSelectareDrum, ploteazaDrum, culoareDrum);
        imgRedimensionata = imrotate(...
            imgRedimensionata, -90);
        imgRedimensionata = micsoreazaLatime(...
            imgRedimensionata, numarPixeliInaltime, metodaSelectareDrum, ploteazaDrum, culoareDrum);
        imgRedimensionata = imrotate(...
            imgRedimensionata, 90);
        
    
    case 'eliminaObiect'
        %completati aici codul vostru 
    
        imgRedimensionata = eliminaObiect(img, culoareDrum, ploteazaDrum, metodaSelectareDrum);
end