function img1 = eliminaDrumVertical(img,drum)
%elimina drumul vertical din imagine
%input: img - imaginea initiala
%       drum - drumul vertical
%output img1 - imaginea initiala din care s-a eliminat drumul vertical
img1 = zeros(size(img,1),size(img,2)-1,size(img,3),'uint8');

for i=1:size(img1,1)
    try
        coloana = drum(i,2);
        %copiem partea din stanga
        img1(i,1:coloana-1,:) = img(i,1:coloana-1,:);
        %copiem partea din dreapta
        %completati aici codul vostru
        
        img1(i, coloana:end, :)= img(i, coloana+1:end, :);
    catch 1
    end
end

% %adaugaDrumVertical ca fctie noua
% 
% function img1 = adaugaDrumVertical(img,drum)
% %elimina drumul vertical din imagine
% %input: img - imaginea initiala
% %       drum - drumul vertical
% %output img1 - imaginea initiala din care s-a eliminat drumul vertical
% img1 = zeros(size(img,1),size(img,2)+1,size(img,3),'uint8');
% 
% for i=1:size(img1,1)
%         coloana = drum(i,2);
%         %copiem partea din stanga
%         img1(i,1:coloana,:) = ...
%             img(i,1:coloana,:);
%         img1(i,1:coloana+1,:) = ...
%             img(i, coloana,:);
%         %copiem partea din dreapta
%         %completati aici codul vostru
%         
%         img1(i, coloana+2:end, :)= ...
%             img(i, coloana+1:end, :);
% end