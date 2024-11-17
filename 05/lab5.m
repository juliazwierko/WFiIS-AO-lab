% czarne tlo, same biale kaczki
clear;clc;close all;
im=rgb2gray(double(imread('kaczki.jpg'))/255);
bim=~imbinarize(im);
bim=imclose(bim,ones(11)); % delatacja, pogrubienie - kaczki + erozja, 
% rozwiazanie problemy
% im = "kaczki.jpg";
figure
h = 4;
w = 3;
subplot(h,w,1)
imshow("kaczki.jpg")
subplot(h,w,2);
imshow(bim);

%operacje morfologiczne
% bim = bwmorph(bim,'remove') %2 arg - funckja ktorej chcemy uzcy : erozja, delatacja, open, close
% erose delate open close;
% fill - wypeknia, jka mamy bialy obiek i pojedyncze czarn epunkty, to
% wypelnia pojedyncze piksele i to ich wypelnia
% clean - to samo jak wyzej tylko z bialymi elementami 
% remove -keawedz wszystkich obiektow
% obeaz - erose, czyli to jest to samo co bin - erose - tp jest dokladnie
% ten sam wynik
subplot(h,w,3);
imshow(bim);


% szkelet 
sk = bwmorph(bim, 'skel', inf); % zbiur wszystkich punktow, srednia medzy krawedziami (odlelosc taka sama)
subplot(h,w,4); % 3 argument - inf, nie musimy wiedziec od ktorej iteracji obraz sie nie zmienia
imshow(sk);

% pt = bwmorph(sk, 'endpoint');
% subplot(h,w,5);
% imshow(pt); % - punkty koncowe szkeletu, patrzymy czy ma wiecej niz 1 sasiada

pt = bwmorph(sk, 'branchpoint');
subplot(h,w,5); % punkty skrzyrzowane, mozemy sobie znalezc dla szkeletu konce i skrzyrzowania 
imshow(pt); 


% jak znalezc wspolrzedne macierzy, indeksy gdzie mamy 1
[y,x] = find(pt);% x>10 zwraca macierz logiczna 


% sk = bwmorph(bim, 'shrink', 10); % sciska piksele do srodka, az na samym koncu nie odstaniemy 1 piksel 
% subplot(h,w,6); % 1 iteracje przypominaja erozja,  
% imshow(sk); % liczna eulera topologiczna, ktor opisuje czy 2 obiekty sa same, topologiczne

%topologia: jesli mamy 2 obiekty, to; liczna eulora - ilsoc obiektow -
%ilsoc dziur 
% ma znaczenie to, czy jakie sprzeksztalcenia zmiena liczbe eulera czy nie 
% erozja - moze sie zmienic ilosc obiektow, jednak shrink to jest tez
% erozja, tylko nie zmienimy ilsoci obiektow 


% sk = bwmorph(bim, 'thin', inf); % to nie jest szkelet, to jak shrink robil erozje jak dlugo jak cos zostawalo, a on redukuje do linii grubosi 1 piksel
% subplot(h,w,6);  % zastosowanie gdzie chcemy badac przebieg linii, i nie intersuje nas grubosc
% imshow(sk); % 2) zdjecie satalitarne rzeki: chcemy zmierzyc dlugosc rzeki 

% sk = bwmorph(bim, 'thicken', 60);  % pogrubienie, obszary sie zachowuja - segmenty
% subplot(h,w,6);  
% imshow(sk);  
%wyswietlenie wybranego segmentu  <przyklad na tablicy z macierzami>

l = bwlabel(bim);
subplot(h,w,6);
imshow(label2rgb(l));

% jak wyswietlac kaczke numer 2???? -> bierzemy macierz o wartoscia 0 1 2 3
% interesuje nas tylko 2! 
subplot(h,w,7);
imshow(label2rgb(l==2));

% a jak policzyc - ilsoc kaczek - wyznaczyc maximum
n = max(l(:));



sgt = bwmorph(bim, 'thicken', inf);
l = bwlabel(sgt);
subplot(h,w,8);
imshow((l==2).*bim .*im); % bez bim - segmenty z jasnoscia, bez ksztaltow
% podzila logiczny: l - podzial , bim - ksztalt, im kolory - to jest
% analiza obrazu, a laczenie - "sinteza"


% kolejny rodzaj segmentacji 
%transformata odleglosciowa: kazdemu punktwoi obrazu przypisujemy od
%najdalszego bialego punktu: jak p. bialy to odl = 0. a czarny - to
%odlgeglosc od tego punktu:
d = bwdist(bim); % odleglosc w pikselach

subplot(h,w,9)
imshow(d,[0,max(d(:))]); % im dalej jestesmy od kraedzi tym jasniej, mapa topologiczna
% mozna rowniez zauwazyc linie - spadek idzie w obu kierunkach - grzbiet
% gorski -> grzbiet ten formalnie nazywa sie szkelet


bim([1,end],:) = 1;
bim(:,[1,end]) = 1;
% transformata odleglosciowa 
% d = bwdist(bim, 'cityblock');  % dwie e metody !
d = bwdist(bim, 'chessboard'); 
subplot(h,w, 10)
imshow(d,[0,max(d(:))]); % zlewisko....  a granica -> wododzial ....

l = watershed(d);
subplot(h,w,10)
imshow(label2rgb(l));
% zastosowanie - uzywanie aparatu matematycznego 

% segmentacja

