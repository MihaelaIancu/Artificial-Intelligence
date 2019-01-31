function imgSintetizata = realizeazaTransferulTexturii(parametri)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

        %%
        %completeaza imaginea de obtinut cu blocuri ales in functie de eroare de suprapunere mica
        suprapunere = overlap*dimBloc;
        nrBlocuriY = ceil((size(imgSintetizata,1)-dimBloc)/(dimBloc-suprapunere))+1;
        nrBlocuriX = ceil((size(imgSintetizata,2)-dimBloc)/(dimBloc-suprapunere))+1;
        sizeH = nrBlocuriY * (dimBloc-suprapunere)+suprapunere;
        sizeW = nrBlocuriX * (dimBloc-suprapunere)+suprapunere;
        sizeC = size(parametri.texturaInitiala,3);
        imgSintetizataMaiMare = uint8(zeros(sizeH,sizeW,sizeC));
        
        %%
        for y=1:nrBlocuriY
            for x=1:nrBlocuriX
                % calculam eroarea / distanta dintre toate piesele si
                % fereastra curenta din imgSintetizataMaiMare
                
                xmin = (x-1)*(dimBloc-suprapunere)+1;
                xmax =  xmin+dimBloc-1;
                if xmax>size(imgSintetizataMaiMare,2)
                    xmax = size(imgSintetizataMaiMare,2);
                end
                ymin = (y-1)*(dimBloc-suprapunere)+1;
                ymax =  ymin+dimBloc-1;
                if ymax>size(imgSintetizataMaiMare,1)
                    ymax = size(imgSintetizataMaiMare,1);
                end
                try
                    fereastra = imgSintetizataMaiMare(ymin:ymax,xmin:xmax,:);
					
                catch E
                    disp(E)
                end
                d = zeros(1,nrBlocuri);
                for indice = 1:nrBlocuri
                    if (x==1 && y==1)
                        try
                        k = randi(nrBlocuri)
                        imgSintetizata(ymin:ymax, xmin:xmax, :) = blocuri(:, :, :, k);
                        catch E
                            disp(E)
                    end   
					if x > 1
                        try
                            A = blocuri(:,1:suprapunere,:,indice);
                            B = fereastra(:,1:suprapunere,:);
                            d(indice) = sum( ( double(A(:)) - double(B(:)) ).^2);
                        catch E
                            disp(E)
                        end
                    end
                    if y > 1
                        A = blocuri(1:suprapunere,:,:,indice);
                        B = fereastra(1:suprapunere,:,:);
                        dist = sum( (double(A(:)) - double(B(:))).^2);
                        if x>1
                            d(indice) = d(indice) + dist;
                        else
                            d(indice) = dist;
                        end
                    end
                    
                    if y>1 && x>1
                        A = blocuri(1:suprapunere,1:suprapunere,:,indice);
                        B = fereastra(1:suprapunere,1:suprapunere,:);
                        dist = sum( ( double(A(:)) - double(B(:))).^2);
                        d(indice) = d(indice) -  dist;
                    end
                distMin = min(d);
                distMin = (1+parametri.eroareTolerata)*distMin;
                locatii = find(d<distMin);
                    end
               
                if numel(locatii)== 0
                    loc = randperm(nrBlocuri);
                    loc = loc(1); 
                else
                    cate = numel(locatii);
                    loc = randperm(cate);
                    loc = locatii(loc(1))
                end
                try
                    imgSintetizataMaiMare(ymin:ymax,xmin:xmax,:) = blocuri(:,:,:,loc);
                catch E
                    disp(E)
                end
                imshow(imgSintetizataMaiMare)
                pause(0.01)
            end
        end
        
        imgSintetizata = imgSintetizataMaiMare(1:size(imgSintetizata,1),1:size(imgSintetizata,2),:);
        
		
        figure, imshow(parametri.texturaInitiala)
        figure, imshow(imgSintetizata);
        title('Rezultat obtinut pentru blocuri selectatate aleator');
        return

end

