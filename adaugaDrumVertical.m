function img1 = adaugaDrumVertical(img,drum)
%adauga drumul vertical din imagine
%input: img - imaginea initiala
%       drum - drumul vertical
%output img1 - imaginea initiala din care s-a adaugat drumul vertical
img1 = zeros(size(img,1),size(img,2)+1,size(img,3),'uint8');

for i=1:size(img1,1)
%     try
        coloana = drum(i,2);
        %copiem partea din stanga
%         img1(i,1:coloana,:) = img(i,1:coloana,:);
%         img1(i,1:coloana+1,:) = img(i,1:coloana,:);
        img1(i,1:coloana-1,:) = img(i,1:coloana-1,:);
        %copiem partea din dreapta
        %completati aici codul vostru
        if coloana == 1
            medieColoana = img(i, coloana, :);
        else
            try
            medieColoana = mean([img(i, coloana, :), ...
                                img(i, coloana-1, :)]);
            catch e
                1
            end
        end
        img1(i, coloana, :) = medieColoana;
        
        if coloana == size(img, 2)
            medieColoana = img(i, coloana, :);
        else
            medieColoana = mean([img(i, coloana, :),...
                                 img(i, coloana+1, :)]);
        end
        img1(i, coloana+1, :) = medieColoana;
%          try
%         medieColoana = (img(i, coloana, :) + img(i, coloana-1, :))/2;
%          catch e
%              e
%          end
%         img1(i, coloana, :) = medieColoana;
%         medieColoana = (img(i, coloana, :) + img(i, coloana+1, :))/2;
%         img1(i, coloana+1, :) = medieColoana;
        img1(i, coloana+2:end, :) = img(i, coloana+1:end, :);
%         img1(i, coloana+2:end,:)= ...
%             img(i, coloana+1:end,:);
%     catch 1
end


