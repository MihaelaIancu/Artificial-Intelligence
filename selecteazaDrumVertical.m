function d = selecteazaDrumVertical(E,metodaSelectareDrum)%selecteaza drumul vertical ce minimizeaza functia cost calculate pe baza lui E
%
%input: E - energia la fiecare pixel calculata pe baza gradientului
%       metodaSelectareDrum - specifica metoda aleasa pentru selectarea drumului. Valori posibile:
%                           'aleator' - alege un drum aleator
%                           'greedy' - alege un drum utilizand metoda Greedy
%                           'programareDinamica' - alege un drum folosind metoda Programarii Dinamice
%
%output: d - drumul vertical ales

d = zeros(size(E,1),2);

switch metodaSelectareDrum %aleatorul face linia rosie care traverseaza imaginea la redimensionare; scade din dr in stg pe orizontala si ma duc in jos si imi da muchiile verticale; vad cat de mult variaza pixelii dintr o parte in alta; daca ajunge la o magnitudine mare(adica linia rosie se intersecteaza cu obiectul, si inseamna ca taie din obiect ca nu are cum sa ocoleasca) exista prob sa avem o muchie; deci tre sa gasesc o metoda care sa faca drumurile astea fara sa taie din muchii => greedy
    case 'aleator'
        %pentru linia 1 alegem primul pixel in mod aleator
        linia = 1;
        %coloana o alegem intre 1 si size(E,2)
        coloana = randi(size(E,2));
        %punem in d linia si coloana coresponzatoare pixelului
        d(1,:) = [linia coloana];
        for i = 2:size(d,1)
            %alege urmatorul pixel pe baza vecinilor
            %linia este i
            linia = i;
            %coloana depinde de coloana pixelului anterior
            if d(i-1,2) == 1%pixelul este localizat la marginea din stanga
                %doua optiuni
                optiune = randi(2)-1;%genereaza 0 sau 1 cu probabilitati egale 
            elseif d(i-1,2) == size(E,2)%pixelul este la marginea din dreapta
                %doua optiuni
                optiune = randi(2) - 2; %genereaza -1 sau 0
            else
                optiune = randi(3)-2; % genereaza -1, 0 sau 1
            end
            coloana = d(i-1,2) + optiune;%adun -1 sau 0 sau 1: 
                                         % merg la stanga, dreapta sau stau pe loc
            d(i,:) = [linia coloana];
        end
    case 'greedy' 
        %completati aici codul vostru
        
        %cu val E cea mai mica de pe primul rand
        %pentru linia 1 alegem primul pixel in mod aleator
        linia = 1;
        %coloana o alegem intre 1 si size(E,2)
        coloana = randi(size(E,2)); %aleasa random; daca las doar linia asta de cod, nu mai taie omul; adica sa comentez urm linie de cod
        [~, coloana] = min(E(1, :)); %toate col de pe primul rand; imi trebuie indicele, nu neaparat valoarea pt ca min returneaza si indicele si valoarea
        %punem in d linia si coloana coresponzatoare pixelului
        d(1,:) = [linia coloana]; % d = drumul; matrice cu linii si coloane; l: 1-H; c: 250 ...
        for i = 2:size(d,1) % pornesc cu i de la urm linie, 2, si merg pana la capat(ul matricei); i = 1 la E
            %alege urmatorul pixel pe baza vecinilor
            %linia este i
            linia = i;
            %coloana depinde de coloana pixelului anterior; daca col ant=1;
            %aleg optiunea in fct de min: [~, poz]=min(E(2, 1:2)); pt linie=2; E(linie,
            %1:2); (0, -1) = size(E, 2) in dr, vezi elseif
            if d(i-1,2) == 1%pixelul este localizat la marginea din stanga, adica col=1; daca drumul anterior de pe col resp = stg -> merg in jos(diag) sau dr
                %doua optiuni
                [~, poz]=min(E(linia, 1:2)); %gasesc min dintre elem meu si cel de dupa el, col 1 si 2 = 1:2; si ii retin pozitia; alege pozitia pixelului cu energia min de pe linia curenta in cazul in care coloana ant = 1; verif pixelul meu cu al doilea, din dr
                optiune = poz - 1;% rand(2)-1 genereaza 0 sau 1 cu probabilitati egale ;imi trebe 0 pt col cur si 1 pt col urm; folosesc valoare col resp sau cele 2 val 0 sau 1; dr=0, -1; stg(mijl)=-1, 0, 1; stg=1
            elseif d(i-1,2) == size(E,2)%pixelul este la marginea din dreapta; adica ma aflu pe col din dr
                %doua optiuni
                [~, poz]=min(E(linia, coloana-1 : coloana)); % iau ce pixelul dinaintea mea si compar cu ce e dupa el; pt dr ma deplasez in stg sau jos(diag)
                optiune = poz - 2; %genereaza -1 sau 0
            else
                [~, poz]=min(E(linia, coloana-1 : coloana+1)); % iau 3 coloane, asta pe care sunt, dinainte si urm; ca e in mijl si ma pot deplasa in dr, stg, jos
                optiune = poz-2; % genereaza -1, 0 sau 1
            end
            coloana = d(i-1,2) + optiune;%adun -1 sau 0 sau 1: 
                                         % merg la stanga, dreapta sau stau pe loc
            d(i,:) = [linia coloana];
            
        end
        
    case 'programareDinamica'
        %completati aici codul vostru
        %->vrem drumul de cost optim
        %->trebuie sa fac o matrice aditionala de aceeasi dim cu E care va
        %tine toate costurile minime pana intr-un punct 
        %->pt prima linie, e la fel ca E
        %->pt a 2a linie, pt un pixel, costul va fi suma dintre costul
        %pixelului resp si minimul dintre cei 3 deasupra lui
        M = zeros(size(E));
        % M(1,:)=E(1,:);
        % M(i, j) = E(i, j)+min([M(i-1, j-1), M(i-1, j), M(i-1, j+1)]);
        %->la ult linie, pt a reconstrui drumul de cost min, ma uit la val min
        %de pe ult linie si apoi iau val min dintre cele 3 de deasupra lui
        %->trebuie tratate dif prima si ult col, adica punem if-uri cand
        %constr matricea
        
        %la fel ca la greedy/aleator, ma misc in fctie de unde ma aflu
        
        for i = 2:size(M, 1)
            for j = 1:size(M, 2)
                if j == 1 %snt pe marg din stg
                    M(i, j) = E(i, j) + min(M(i-1, j:j+1)); 
                elseif j == size(M, 2) %marg din dr
                    M(i, j) = E(i, j) + min(M(i-1, j-1:j)); 
                else %oriunde altundeva
                    M(i, j) = E(i, j) + min(M(i-1, j-1:j+1)); 
                end
             end
        end

        
        %pt linie, coloana
        linia = size(M, 1);
        [~, coloana] = min(M(linia, :)); % pe ult linie aleg min
        d(linia, :) = [linia, coloana]; %greedy facut de jos in sus
        for i = size(M, 1)-1:-1:1 % ma duc de la penultima linie cu pasul -1 pana la 1
            %aleg col de deasupra care mi va da drumul, o aleg in fctie de
            %min
            linia = i;
            if d(i+1,2) == 1
                [~, poz] = min(M(linia, 1 : 2));
                optiune = poz - 1;
            elseif d(i+1,2) == size(M, 2)
                [~, poz] = min(M(linia, coloana-1 : coloana));
                optiune = poz - 2;
            else %acelasi cod ca la greedy
                [~, poz] = min(M(linia, coloana-1:coloana+1));
                optiune = poz - 2; %exact la fel ca la greedy pe matricea M
            end
     
           
            coloana = d(i+1,2) + optiune;%adun -1 sau 0 sau 1:
                                         %merg la stanga, dreapta sau stau pe loc
             d(i,:) = [linia coloana];
          
        end
        
    otherwise
        error('Optiune pentru metodaSelectareDrum invalida');
end

end