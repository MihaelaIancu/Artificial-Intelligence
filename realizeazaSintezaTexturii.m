function imgSintetizata = realizeazaSintezaTexturii(parametri)

dimBloc = parametri.dimensiuneBloc;
nrBlocuri = parametri.nrBlocuri;

[inaltimeTexturaInitiala,latimeTexturaInitiala,nrCanale] = size(parametri.texturaInitiala);
H = inaltimeTexturaInitiala;
W = latimeTexturaInitiala;
c = nrCanale;

H2 = parametri.dimensiuneTexturaSintetizata(1);
W2 = parametri.dimensiuneTexturaSintetizata(2);
overlap = parametri.portiuneSuprapunere;

% o imagine este o matrice cu 3 dimensiuni: inaltime x latime x nrCanale
% variabila blocuri - matrice cu 4 dimensiuni: punem fiecare bloc (portiune din textura initiala) 
% unul peste altul 
dims = [dimBloc dimBloc c nrBlocuri];
blocuri = uint8(zeros(dims(1), dims(2),dims(3),dims(4)));

%selecteaza blocuri aleatoare din textura initiala
%genereaza (in maniera vectoriala) punctul din stanga sus al blocurilor
y = randi(H-dimBloc+1,nrBlocuri,1);
x = randi(W-dimBloc+1,nrBlocuri,1);
%extrage portiunea din textura initiala continand blocul
for i =1:nrBlocuri
    blocuri(:,:,:,i) = parametri.texturaInitiala(y(i):y(i)+dimBloc-1,x(i):x(i)+dimBloc-1,:);
end

imgSintetizata = uint8(zeros(H2,W2,c));
nrBlocuriY = ceil(size(imgSintetizata,1)/dimBloc);
nrBlocuriX = ceil(size(imgSintetizata,2)/dimBloc);
imgSintetizataMaiMare = uint8(zeros(nrBlocuriY * dimBloc,nrBlocuriX * dimBloc,size(parametri.texturaInitiala,3)));

switch parametri.metodaSinteza
    
    case 'blocuriAleatoare'
        %%
        %completeaza imaginea de obtinut cu blocuri aleatoare
        for y=1:nrBlocuriY
            for x=1:nrBlocuriX
                i = randi(nrBlocuri);
                imgSintetizataMaiMare((y-1)*dimBloc+1:y*dimBloc,(x-1)*dimBloc+1:x*dimBloc,:)=blocuri(:,:,:,i);
            end
        end
        
        imgSintetizata = imgSintetizataMaiMare(1:size(imgSintetizata,1),1:size(imgSintetizata,2),:);
        
        figure, imshow(parametri.texturaInitiala)
        figure, imshow(imgSintetizata);
        title('Rezultat obtinut pentru blocuri selectatate aleator');
        return

       
 case 'eroareSuprapunere'
      %% case 'eroareSuprapunere'
        %completeaza imaginea de obtinut cu blocuri ales in functie de eroare de suprapunere
        suprapunere = overlap*dimBloc;
        nrBlocuriY = ceil(( size(imgSintetizata,1) - dimBloc)/(dimBloc - suprapunere)) + 1;
        nrBlocuriX = ceil(( size(imgSintetizata,2)-dimBloc)/(dimBloc - suprapunere)) +1;
        
        dimX = (nrBlocuriY-1) * (dimBloc-suprapunere)+dimBloc;
        dimY = (nrBlocuriX-1) * (dimBloc-suprapunere)+dimBloc;
        dimC = size(parametri.texturaInitiala,3);
        
        imgSintetizataMaiMare = uint8(zeros(dimY,dimX,dimC));
        figure;
        
        for y=1:nrBlocuriY
            for x=1:nrBlocuriX
                
                CXmin = (y-1)*(dimBloc-suprapunere)+1;
                Cymin = (x-1)*(dimBloc-suprapunere)+1;
                CXmax = CXmin + dimBloc-1;
                Cymax = Cymin + dimBloc-1;
                
                try
                fereastra = imgSintetizataMaiMare(CXmin:CXmax,Cymin:Cymax,:);
                catch 1
%                 catch E
%                     disp(E)
                end
                d = zeros(1,nrBlocuri);
                for i = 1:nrBlocuri
                    if x>1
                        A = fereastra(:,1:suprapunere,:);
                        B = blocuri(:,:,:,i);
                        B = B(:,1:suprapunere,:);
                        d(i) = sum( (double(A(:)) - double(B(:))).^2 );
                    end
                    if y>1
                        A = fereastra(1:suprapunere,:,:);
                        B = blocuri(:,:,:,i);
                        B = B(1:suprapunere,:,:);
                        dist = sum( (double(A(:)) - double(B(:))).^2 );
                        if x>1
                            d(i) = d(i) + dist;
                            A = fereastra(1:suprapunere,1:suprapunere,:);
                            B = blocuri(:,:,:,i);
                            B = B(1:suprapunere,1:suprapunere,:);
                            dist2 = sum( (double(A(:)) - double(B(:))).^2 );
                            d(i) = d(i) - dist2;
                        else
                            d(i) = dist;
                        end
                    end
                    
                end
                
                 if sum(d) == 0
                    minimPoz = randi(nrBlocuri);
                else
                    [minimVal, minimPoz] = min(d);
                end

                imgSintetizataMaiMare(CXmin:CXmax,Cymin:Cymax,:) = blocuri(:,:,:,minimPoz(1));

                imshow(imgSintetizataMaiMare);
            end
        end

        imgSintetizata = imgSintetizataMaiMare(1:size(imgSintetizata,1),1:size(imgSintetizata,2),:);
        
        figure, imshow(parametri.texturaInitiala)
        figure, imshow(imgSintetizata);
        title('Rezultat obtinut pentru blocuri selectate in functie de eroarea de suprapunere');
        return
        
    case 'frontieraCostMinim'
        %
        %completeaza imaginea de obtinut cu blocuri ales in functie de eroare de suprapunere + forntiera de cost minim
        
         %%
        %completeaza imaginea de obtinut cu blocuri ales in functie de eroare de suprapunere         
	
        % if size(img, 3)== 3
%         img = rgb2gray(imgSintetizata);
%         % end
% 
%         f = -fspecial ('sobel');
%         fX = imfilter (int16(img), f, 'replicate');
%         fY = imfilter (int16(img), f','replicate');
%         En = sqrt(double(fX.^2 + fY.^2));
%         
%         M = zeros(size(En));
%         
        suprapunere = round(dimBloc * overlap);
        nrBlocuriY = floor((size(imgSintetizata, 1)- dimBloc)/(dimBloc - suprapunere))+1;
        nrBlocuriX = floor((size(imgSintetizata, 2)- dimBloc)/(dimBloc - suprapunere))+1;
%         
%         dimX = (nrBlocuriY-1) * (dimBloc-suprapunere)+dimBloc;
%         dimY = (nrBlocuriX-1) * (dimBloc-suprapunere)+dimBloc;
%         dimC = size(parametri.texturaInitiala,3);
%         
%         imgSintetizataMaiMare = uint8(zeros(dimY,dimX,dimC));
%         figure;
%         
%         %imgSintetizataMaiMare = uint8(zeros((nrBlocuriY-1) * (dimBloc-suprapunere)+dimBloc, (nrBlocuriX-1) * (dimBloc - suprapunere) + dimBloc, size(parametri.texturaInitiala, 3)));
%         
%         for y = 1:nrBlocuriY
%             for x = 2:nrBlocuriX
%                 
%                 CXmin = (y-1)*(dimBloc-suprapunere)+1;
%                 Cymin = (x-1)*(dimBloc-suprapunere)+1;
%                 CXmax = CXmin + dimBloc-1;
%                 Cymax = Cymin + dimBloc-1;
%                 
%                 if y == 1 
%                     M(x, y) = En(x, y) + min(M(x-1, y:y+1));
%                 elseif y == nrBlocuriY
%                     M(x, y) = En(x, y) + min(M(x-1, y-1:y));
%                 else
%                     M(x, y) = En(x, y) + min(M(x-1, y-1:y+1));
%                 end
%             end
%         end
% %                 try
% %                     fereastra = imgSintetizataMaiMare(CXmin:CXmax,Cymin:Cymax,:);
% %                     %fereastra = imgSintetizataMaiMare((y-1)*(dimBloc-suprapunere)+1:y*(dimBloc-suprapunere)+suprapunere, (x-1)*(dimBloc-suprapunere)+1:x*(dimBloc-suprapunere)+suprapunere,:);
% %                 catch
% %                     En
% %                     disp(En)
% %                 end
% 
%                  linia = nrBlocuriX;
%                  %d = zeros(1, nrBlocuri);
%                  [~, coloana] = min(M(linia, :));
%                  d(linia, :) = [linia, coloana];
% 
%                  for i = nrBlocuriX-1:-1:1
%                      linia = i;
%                   
%                  if d(i+1, 2) == 1
%                      [~, poz] = min(M(linia, 1:2));
%                      optiune = poz - 1;
%                  elseif d(i+1, 2) == nrBlocuriY
%                      [~, poz] = min(M(linia, coloana-1 : coloana));
%                      optiune = poz - 2;
%                  else
%                      [~, poz] = min(M(linia, coloana - 1: coloana+1));
%                      optiune = poz - 2;
%                  end
%                  
%                  coloana = d(i+1, 2) + optiune;
%                  d(i, :) = [linia, coloana];
%                 
%                  end
% %                 for i = 1:nrBlocuri
% %                     if x>1
% %                         A = fereastra(:, 1:suprapunere, :);
% %                         B = blocuri(:, :, :, i);
% %                         B = B(:, 1:suprapunere, :);
% %                         d(i) = sum(double(A(:))-double(B(:)).^2);
% %                     end
% %                     if y > 1
% %                         A = fereastra(1:suprapunere, :, :);
% %                         B = blocuri(:, :, :, i);
% %                         B = B(1:suprapunere, :, :);
% %                         dist = sum(double(A(:))-double(B(:)).^2);
% %                         if x>1
% %                             A = fereastra(1:suprapunere, 1:suprapunere, :);
% %                             B = blocuri(:, :, :, i);
% %                             B = B(1:suprapunere, 1:suprapunere, :);
% %                             dist2 = sum(double(A(:))-double(B(:)).^2);
% %                             d(i) = d(i) + dist - dist2;
% %                         else
% %                             d(i) = dist;
% %                         end
% %                     end
% %                 end
% 
%                
%                 %vom extrage min din d si vom stii blocul potrivit
%                 %pt fereastra
%                 if sum(d) == 0
%                     minimPoz = randi(nrBlocuri);
%                 else
%                     [~, minimPoz] = min(d);
%                 end
% %                 try
% %                 imgSintetizataMaiMare((y-1)*(dimBloc-suprapunere)+1:y*(dimBloc-suprapunere)+suprapunere,(x-1)*(dimBloc-suprapunere)+1:(x*(dimBloc-suprapunere)+suprapunere),:) = blocuri(:, :, :, minimPoz(1));
% %                 catch
% %                     1
% %                 end
%                 imgSintetizataMaiMare(CXmin:CXmax,Cymin:Cymax,:) = blocuri(:,:,:,minimPoz(1));
%                 imshow(imgSintetizataMaiMare);
%             end
%         %end
%         
%         
%         imgSintetizata = imgSintetizataMaiMare(1:size(imgSintetizata,1),1:size(imgSintetizata,2),:);
%         
%         figure, imshow(parametri.texturaInitiala)
%         figure, imshow(imgSintetizata);

%   suprapunere = overlap*dimBloc;
%         nrBlocuriY = ceil(( size(imgSintetizata,1) - dimBloc)/(dimBloc - suprapunere)) + 1;
%         nrBlocuriX = ceil(( size(imgSintetizata,2)-dimBloc)/(dimBloc - suprapunere)) +1;
        
        dimX = (nrBlocuriY-1) * (dimBloc-suprapunere)+dimBloc;
        dimY = (nrBlocuriX-1) * (dimBloc-suprapunere)+dimBloc;
        dimC = size(parametri.texturaInitiala,3);
        
        imgSintetizataMaiMare = uint8(zeros(dimY,dimX,dimC));
        figure;
        
          d = zeros(1,nrBlocuri);
                        
        for y=1:nrBlocuriY
            for x=1:nrBlocuriX
                
                CXmin = (y-1)*(dimBloc-suprapunere)+1;
                CYmin = (x-1)*(dimBloc-suprapunere)+1;
                CXmax = CXmin + dimBloc-1;
                CYmax = CYmin + dimBloc-1;
%                 
%                 if( x==1 && y==1) k = randi(nrBlocuri);
%                     imgSintetizataMaiMare(CYmin:CYmax,CXmin:CXmax,:) = blocuri(:, :, :, k);
%                 end
                
                try
                 fereastra = imgSintetizataMaiMare(CXmin:CXmax,CYmin:CYmax,:);
                catch 1
% %                 catch E
% %                     disp(E)
                end
                
                for i = 1:nrBlocuri
                    if x>1
%                         imgS = imgSintetizataMaiMare(CYmin:CYmax,CXmin:CXmin + suprapunere - 1,:)
                        A = fereastra(:,1:suprapunere,:);
                        B = blocuri(:,:,:,i);
                        B = B(:,1:suprapunere,:);
                        d(i) = sum( (double(A(:)) - double(B(:))).^2 );
                    end
                    if y>1
%                         imgS = imgSintetizataMaiMare(CYmin:CYmin + suprapunere - 1,CXmin:CXmax,:)
                        A = fereastra(1:suprapunere,:,:);
                        B = blocuri(:,:,:,i);
                        B = B(1:suprapunere,:,:);
                        dist = sum( (double(A(:)) - double(B(:))).^2 );
                        if x>1
%                             imgS = imgSintetizataMaiMare(CYmin:CYmin + suprapunere - 1,CXmin:CXmin + suprapunere - 1,:)
                            d(i) = d(i) + dist;
                            A = fereastra(1:suprapunere,1:suprapunere,:);
                            B = blocuri(:,:,:,i);
                            B = B(1:suprapunere,1:suprapunere,:);
                            dist2 = sum( (double(A(:)) - double(B(:))).^2 );
                            d(i) = d(i) - dist2;
                        else
                            d(i) = dist;
                        end
                    end
                    
            end
                
              
                 if sum(d) == 0
                    minimPoz = randi(nrBlocuri);
                else
                    [minimVal, minimPoz] = min(d);
                end

                imgSintetizataMaiMare(CXmin:CXmax,CYmin:CYmax,:) = blocuri(:,:,:,minimPoz(1));

                imshow(imgSintetizataMaiMare);
            end
        end

%        imgSintetizata = imgSintetizataMaiMare(1:size(imgSintetizata,1),1:size(imgSintetizata,2),:);
        
        figure, imshow(parametri.texturaInitiala)
        figure, imshow(imgSintetizataMaiMare);

        title('Rezultat -> eroarea de suprapunere, folosind frontiera de cost minim');
        return
       
end
       
    
