function params = incarcaPieseMozaic(params)
%citeste toate cele N piese folosite la mozaic din directorul corespunzator
%toate cele N imagini au aceeasi dimensiune H x W x C, unde:
%H = inaltime, W = latime, C = nr canale (C=1  gri, C=3 color)
%functia intoarce pieseMozaic = matrice H x W x C x N in params
%pieseMoziac(:,:,:,i) reprezinta piese numarul i 

fprintf('Incarcam piesele pentru mozaic din director \n');
%completati codul Matlab
filelist = dir([params.numeDirector '/*.' params.tipImagine]);%concatenarea se face cu spatiu si [] si am doar imagini, nu mai apare "." si ".."
%x=1

img = imread([params.numeDirector '/' filelist(7).name]);
dim = size(img); %F10 trece cu break point ul o linie mai jos
pieseMozaic = uint8(zeros([dim length(filelist)])); %matrice/ uint8 pt ca zeros e cu double

for i = 1:length(filelist)
    img = imread([params.numeDirector '/' filelist(i).name]);
    pieseMozaic(:, :, :, i) = img; %copiez imaginile in pieseMozaic
   
end

if params.afiseazaPieseMozaic
    %afiseaza primele 100 de piese ale mozaicului
    figure,
    title('Primele 100 de piese ale mozaicului sunt:');
    idxImg = 0;
    for i = 1:10
        for j = 1:10
            idxImg = idxImg + 1;
            subplot(10,10,idxImg);
            imshow(pieseMozaic(:,:,:,idxImg));
        end
    end
    drawnow;
    pause(2);
end


params.pieseMozaic = pieseMozaic;