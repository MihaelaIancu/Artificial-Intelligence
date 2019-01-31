function imgMozaic = adaugaPieseMozaicPeCaroiaj(params)
%
%tratati si cazul in care imaginea de referinta este gri (are numai un canal)

imgMozaic = uint8(zeros(size(params.imgReferintaRedimensionata)));
[H,W,C,N] = size(params.pieseMozaic);
[h,w,c] = size(params.imgReferintaRedimensionata);


switch(params.criteriu)
    case 'aleator'
        
        %pune o piese aleatoare in mozaic, nu tine cont de nimic
        
        nrTotalPiese = params.numarPieseMozaicOrizontala * params.numarPieseMozaicVerticala;
        nrPieseAdaugate = 0;
        

        
        for i =1:params.numarPieseMozaicVerticala
            for j=1:params.numarPieseMozaicOrizontala
              
                %alege un indice aleator din cele N
                
                indice = randi(N);    
                imgMozaic((i-1)*H+1:i*H,(j-1)*W+1:j*W,:) = params.pieseMozaic(:,:,:,indice);
                nrPieseAdaugate = nrPieseAdaugate+1;
                fprintf('Construim mozaic ... %2.2f%% \n',100*nrPieseAdaugate/nrTotalPiese);
            end
        end
        
      
        
    case 'distantaCuloareMedie'
        %completati codul Matlab
        nrTotalPiese = params.numarPieseMozaicOrizontala * params.numarPieseMozaicVerticala;
        nrPieseAdaugate = 0;
        for i = 1: size(params.pieseMozaic,4)
            vmR = mean(mean(params.pieseMozaic(:,:,1,i)));%calc cul medie pe fiecare canal
            vmG = mean(mean(params.pieseMozaic(:,:,2,i)));
            vmB = mean(mean(params.pieseMozaic(:,:,3,i)));
            
            CuloareMediePiese(i,:) = [vmR vmG,vmB];%bag in vector
        end
        
%         fac o matrice de dimen piesevert * pieseoriz
        
          M = [params.numarPieseMozaicOrizontala params.numarPieseMozaicVerticala];
          
%        params.imgReferintaRedimensionata for i:2:10 -> 2 4 6 8 10 
%        for i =1:size(params.pieseMozaic(:,:,:,1),1):size(params.imgReferintaRedimensionata,1)%merge din piesa in piesa pe orizontala
%           for j=1:size(params.pieseMozaic(:,:,:,1),2):size(params.imgReferintaRedimensionata,2)
       
         for i =1:params.numarPieseMozaicVerticala
            for j=1:params.numarPieseMozaicOrizontala
              
               % extrag ferestre din imgReferintaRedimensionata
               % fereastra = params.imgReferintaRedimensionata(i:i+size(params.pieseMozaic(:,:,:,1),1)-1, j:j+size(params.pieseMozaic(:,:,:,1),2)-1,:);
              
               fereastra = params.imgReferintaRedimensionata((i-1)*H+1:i*H,(j-1)*W+1:j*W,:);
              
                if (size(params.imgReferinta,3) == 3)
                  
               fmR = mean(mean(fereastra(:,:,1))); 
               fmG = mean(mean(fereastra(:,:,2)));
               fmB = mean(mean(fereastra(:,:,3)));
               
               % Calculez dist euclidiana
%                for k = 1:size(CuloareMediePiese,1)
%                   de(k) = sqrt(sum( (CuloareMediePiese(k,:)-[fmR, fmG, fmB]).^2 )) ;
%                end

               de = sqrt(sum( ((CuloareMediePiese-repmat([fmR, fmG, fmB],[size(CuloareMediePiese,1),1])).^2 ) ,2));
               
               % Aleg cea mai mica valoare din de
               
               [~, locatii] = min(de); %unde se afla min pe linie, matricea e coloana, deci am doar 1 indicw pt fiecare de                      
              
               %c)
               
%                for k = 1:size(CuloareMediePiese,1)
%                   de(k) = sqrt(sum( (CuloareMediePiese(k,:)-[fmR, fmG, fmB]).^2 )) ;
%                end
               
%                C(i,j) = locatii(1); %incarca locatia curenta

               if i==1 && j~=1 %daca se afla pe prima linie
                   while locatii==C(i,j-1)
                       de(locatii)=50000; %nu mai exista min vechi ca am de la 0 la 255
                       [a, locatii] = min(de);
                   end
               end
                       
               if i~=1 && j==1
                   while locatii==C(i-1,j)
                       de(locatii)=50000;
                       [a, locatii] = min(de);
                   end
               end
               
               if i~=1 && j~=1
                   while (locatii==C(i-1,j-1)) || (C(i-1,j)==locatii) || (C(i,j-1)==locatii) 
                       de(locatii)=50000;
                       [a, locatii] = min(de);
                   end
               end
              C(i, j) = locatii;
                
%                 if i==1&j~=1
%                     while locatii==matrice(i,j-1)
%                         de(locatii)=6000;
%                         [val,locatii]=min(de);
%                     end
%                 end
%                     if i~=1&j==1 
%                         while locatii==matrice(i-1,j)
%                             de(locatii)=6000;
%                         [val,locatii]=min(de);
%                         end
%                     end
%                     if i~=1&j~=1
%                 while locatii==matrice(i-1,j-1)|matrice(i-1,j)==locatii|matrice(i,j-1)==locatii
%                     de(locatii)=6000;
%                     [val,locatii]=min(de);
%                 end
%                     end
%                     
%                 matrice(i,j)=locatii;
                
                imgMozaic((i-1)*H+1:i*H,(j-1)*W+1:j*W,:) = params.pieseMozaic(:,:,:,locatii(1));
                %imgMozaic(i:i+size(params.pieseMozaic(:,:,:,1),1)-1, j:j+size(params.pieseMozaic(:,:,:,1),2)-1,:) = params.pieseMozaic(:,:,:,locatii(1));
                nrPieseAdaugate = nrPieseAdaugate+1;
                fprintf('Construim mozaic ... %2.2f%% \n',100*nrPieseAdaugate/nrTotalPiese);
%             
                end
                
                %grayscale
                if (size(params.imgReferinta,3) == 1)
                  
               % Calculez dist euclidiana
%                for k = 1:size(CuloareMediePiese,1)
%                   de(k) = sqrt(sum( (CuloareMediePiese(k,:)-[fmR, fmG, fmB]).^2 )) ;
%                end
                de = sqrt(sum( ((CuloareMediePiese-mean(mean(fereastra))).^2 ) ,2));
               % Aleg cea mai mica valoare din de
               [~, locatii] = min(de); %unde se afla min pe linie, matricea e coloana, deci am doar 1 indicw pt fiecare de                      
               
               
                imgMozaic((i-1)*H+1:i*H,(j-1)*W+1:j*W,:) = params.pieseMozaic(:,:,locatii);
                %imgMozaic(i:i+size(params.pieseMozaic(:,:,1),1)-1, j:j+size(params.pieseMozaic(:,:,1),2)-1,:) = params.pieseMozaic(:,:,locatii);
                nrPieseAdaugate = nrPieseAdaugate+1;
                fprintf('Construim mozaic ... %2.2f%% \n',100*nrPieseAdaugate/nrTotalPiese);
                end
                
            end
         end
        
          
    otherwise
        printf('EROARE, optiune necunoscuta \n');  
    
                    
            end
                     end
    
    
    
    
    
