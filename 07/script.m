clear;
clc;
close all;

% Wczytanie obrazu, przekształcenie na format zmiennoprzecinkowy i normalizacja
im = double(imread("ptaki.jpg"))/255;
gim = rgb2gray(im); % Konwersja do skali szarości

% Tworzenie binarnej maski na podstawie kanałów R i B
r = imbinarize(im(:,:,1), .3); % Binarna maska na podstawie kanału czerwonego
b = imbinarize(im(:,:,3), .5); % Binarna maska na podstawie kanału niebieskiego
bim = r | ~b; % Łączenie obu masek
bim = imopen(bim, ones(7)); % Otwarcie obrazu (morfologiczne)
l = bwlabel(bim); % Etykietowanie obiektów
a = regionprops(l == 3, "all"); % Właściwości regionów dla etykiety 3 (np. kaczki)

% Definicja funkcji cech
fm = {@AO5RBlairBliss, @AO5RCircularityL, @AO5RCircularityS, @AO5RDanielsson, @AO5RFeret, @AO5RHaralick, @AO5RMalinowska, @AO5RShape};
M = zeros(max(l, [], "all"), length(fm)); % Inicjalizacja macierzy cech

% Obliczanie cech dla każdego regionu
for i = 1:length(fm)
    for j = 1:max(l, [], "all")
        M(j, i) = fm{i}(l == j);
    end
end

% Obliczanie średnich i odchyleń standardowych dla cech
m = mean(M);
S = std(M);
outS = abs(M - m) ./ S; % Normalizacja cech
t = 1.8; % Próg wartości nietypowych
outS > t; % Wypisanie macierzy logicznej, 1 dla wartości > 1.8 (nietypowe)
out = sum(outS > t, 2) > 3; % Wektor z sumami nietypowych wartości
M(out, :) = []; % Usunięcie z macierzy nietypowych obiektów
indx = find(out);

% Usunięcie nietypowych regionów z etykiet
for i = indx
    l(l == i) = 0;
end

% Tworzenie nowej binarnej maski
bim = l > 0;

% Obliczanie cech dla usuniętych obiektów
fm = {@AO5RBlairBliss, @AO5RCircularityL, @AO5RCircularityS, @AO5RDanielsson, @AO5RFeret, @AO5RHaralick, @AO5RMalinowska, @AO5RShape};
M = zeros(max(l, [], "all"), length(fm)); 
for i = 1:length(fm)
    for j = 1:max(l, [], "all")
        M(j, i) = fm{i}(l == j);
    end
end

% Wczytanie drugiego obrazu i jego przekształcenie na skale szarości
im = double(imread("ptaki2.jpg")) / 255;
gim = rgb2gray(im);

% Tworzenie binarnej maski na podstawie kanałów R i B
r = imbinarize(im(:,:,1), .86);
b = imbinarize(im(:,:,3), .67);
bim = r | ~b; % Łączenie obu masek
bim = imopen(bim, ones(7)); % Otwarcie obrazu
l2 = bwlabel(bim); % Etykietowanie obiektów
a = regionprops(l2 == 3, "all"); % Właściwości regionów dla etykiety 3

% Obliczanie cech dla drugiego obrazu
fm = {@AO5RBlairBliss, @AO5RCircularityL, @AO5RCircularityS, @AO5RDanielsson, @AO5RFeret, @AO5RHaralick, @AO5RMalinowska, @AO5RShape};
M2 = zeros(max(l2, [], "all"), length(fm)); 
for i = 1:length(fm)
    for j = 1:max(l2, [], "all")
        M2(j, i) = fm{i}(l2 == j);
    end
end

% Usunięcie niechcianych wartości z drugiego obrazu
m = mean(M2);
S = std(M2);
outS = abs(M2 - m) ./ S;
t = 800; % Próg wartości
outS > t;
out = sum(outS > t, 2) > 3; 
M2(out, :) = []; 

% Usunięcie małych obiektów na podstawie obszaru
for i = 1:max(l2, [], 'all')
    a = regionprops(l2 == i, 'Area');
    if a.Area < t
        l2(l2 == i) = 0; % Usunięcie obiektów o małym obszarze
    end
end

% Tworzenie nowej binarnej maski dla drugiego obrazu
bim = l2 > 0;
l2 = bwlabel(bim);

% Generowanie wykresu obrazu
imshow(bim); 

% Obliczanie cech dla drugiego obrazu
fm = {@AO5RBlairBliss, @AO5RCircularityL, @AO5RCircularityS, @AO5RDanielsson, @AO5RFeret, @AO5RHaralick, @AO5RMalinowska, @AO5RShape};
M2 = zeros(max(l2, [], "all"), length(fm));
for i = 1:length(fm)
    for j = 1:max(l2, [], "all")
        M2(j, i) = fm{i}(l2 == j);
    end
end

% Przekształcanie danych do sieci neuronowej
uin = [M(1:end-2,:); M2(1:end-2,:)]'; % Wektory wejściowe
n = max(l, [], 'all'); 
n2 = max(l2, [], 'all'); 
uout = [repmat([1;0], 1, n-2), repmat([0;1], 1, n2-2)]; % Wektory wyjściowe
tin = [M(end-1:end,:); M2(end-1:end,:)]'; 
tout = [1, 1, 0, 0; 0, 0, 1, 1]; % Wektory wyjściowe dla testów

% Trenowanie sieci neuronowej
nm = feedforwardnet; 
nm = train(nm, uin, uout);

% Testowanie sieci
round(nm(M(5,:)')) 
round(nm(tin))
