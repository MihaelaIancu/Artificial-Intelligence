function imgMozaic = adaugaPieseMozaicAleator( params )
%pixeliDescoperiti=1;

masca=zeros(size(params.imgReferintaRedimensionata,1),size(params.imgReferintaRedimensionata,2));
pixeliDescoperiti=1;
imgMozaic=zeros(size(params.imgReferintaRedimensionata));
%h,w pt piesa
[h,w,~]=size(params.pieseMozaic(:,:,:,1));
%h,w pt imagine referinta
[H,W,~]=size(params.imgReferintaRedimensionata)
[L,C]=find(masca==0);
while pixeliDescoperiti
    
    %cate elemente am in L sau in C atat dau ca parametru
    %aici voi lua dupa de (fac culoarea medie pe canale si conform min(de)
    %aleg(calculez in afara while culoare medie pt fiecare piesa apoi
    %min(de) va fi folost pt index
    %cu locatie pun
    index=randi(numel(L));
    indexPiesa=randi(size(params.pieseMozaic,4));
    %testez daca piesa iese din imagine
    if L(index)+h-1>H && C(index)+w-1>W
        try
            imgMozaic(L(index):H,...
                C(index):W,:)=...
                params.pieseMozaic(1:H-h+1,1:W-w+1,:,indexPiesa);
            masca(L(index):H,C(index):W)=1;
        catch 1
        end;
        
    elseif L(index)+h-1>H
        try
            imgMozaic(L(index):H,...
                C(index): C(index)+w-1,:)=...
                params.pieseMozaic(1:H-L(index)+1,:,:,indexPiesa);
            masca(L(index):H,C(index):C(index)+w-1)=1;
        catch 1
        end;
        
    elseif   C(index)+w-1>W
        try
            imgMozaic(L(index):L(index)+h-1,...
                C(index):W,:)=...
                params.pieseMozaic(:,1:W-C(index)+1,:,indexPiesa);
            masca(L(index):L(index)+h-1,C(index):W)=1;
        catch 1
        end;
        
    else
        try
            imgMozaic(L(index):L(index)+h-1,...
                C(index):C(index)+w-1,:)=...
                params.pieseMozaic(:,:,:,indexPiesa);
            masca(L(index):L(index)+h-1,...
                C(index):C(index)+w-1)=1;
        catch 1
        end;
        
    end
    
    
    
    [L,C]=find(masca==0);
    nrTotalPixeli = size(masca,1)*size(masca,2);
    fprintf('Pixeli descoperiti ... %2.2f%% \n',100*numel(L)/nrTotalPixeli);
%     if (100*numel(L)/nrTotalPixeli<50) pixeliDescoperiti=0;
%     end
    
end
end

