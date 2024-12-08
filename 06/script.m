clear;
im = double(imread('ptaki.jpg')) / 255; % Wczytywanie obrazu i normalizacja
h = 3; % Wysokość subgrafiki
w = 2; % Szerokość subgrafiki

% Podział na warstwy RGB
r = imbinarize(im(:,:,1)); % Binarna maska dla czerwonego kanału
b = imbinarize(im(:,:,3)); % Binarna maska dla niebieskiego kanału

bim = r | ~b; % Operacja logiczna na warstwach
bim = imclose(bim, ones(5)); % Zamknięcie - usuwanie małych dziur
bim = imopen(bim, ones(5)); % Otwarcie - usuwanie małych obiektów

% Wyświetlanie obrazu po wstępnej obróbce
figure;
subplot(h, w, 1);
imshow(bim);
title('Po operacjach otwarcia i zamknięcia');
% Zapisywanie obrazu
imwrite(bim, 'obraz_po_otwarciu_zamknieciu.png');

% Etykietowanie obiektów
l = bwlabel(bim);
n = max(l(:)); % Liczba obiektów w obrazie

% Wyciąganie właściwości obiektów
a = regionprops(l == 4, 'all'); % Właściwości obiektu o indeksie 4

% Macierz współczynników geometrii
f = {@AO5RBlairBliss, @AO5RCircularityL, @AO5RCircularityS, @AO5RDanielsson, @AO5RFeret, @AO5RHaralick, @AO5RMalinowska, @AO5RShape};
fun_size = 8;
macierz_wsp_gesi = ones(n, fun_size);

for i = 1:n
    for j = 1:fun_size
        macierz_wsp_gesi(i, j) = f{j}(l == i); % Obliczanie współczynników geometrycznych
    end
end

% Wyświetlanie obrobionego obrazu
subplot(h, w, 2);
imshow(bim);
title('Obraz po usunięciu krawędziowych obiektów');
% Zapisywanie obrazu
imwrite(bim, 'obraz_po_usunieciu_krabedziowych_obiektow.png');

% Liczenie średniej i odchylenia standardowego dla współczynników
mg = mean(macierz_wsp_gesi); % Średnia w kolumnach
sg = std(macierz_wsp_gesi);  % Odchylenie standardowe w kolumnach

% Normalizacja współczynników
c = (macierz_wsp_gesi - mg) ./ sg;

% Obliczanie współczynników bez kaczki na skraju
for i = 1:n
    tM = macierz_wsp_gesi;
    tM(i, :) = []; % Usuwanie kaczki z indeksu i
    mg = mean(tM); % Średnia bez tej kaczki
    sg = std(tM);  % Odchylenie standardowe bez tej kaczki
    c(i, :) = (macierz_wsp_gesi(i, :) - mg) ./ sg; % Normalizacja
end

% Testowanie wartości odstających (większych niż 3 sigmy)
test = abs(c) > 3; 
test = sum(test, 2) > 1; % Sprawdzanie, które obiekty mają więcej niż 1 współczynnik przekraczający 3 sigmy

% Usuwanie kaczek z odstającymi wartościami
indx = find(test); % Indeksy kaczek z odstającymi wartościami
bim(l == indx) = 0; % Ustawianie na 0 obiektów z odstającymi wartościami

% Wyświetlanie obrazu po usunięciu kaczek
subplot(h, w, 3);
imshow(bim);
title('Po usunięciu kaczek z odstającymi wartościami');
% Zapisywanie obrazu
imwrite(bim, 'obraz_po_usunieciu_odstajacych_kaczek.png');

% Etykietowanie obiektów po usunięciu kaczek
l = bwlabel(bim);
n = max(l(:));

% Wyświetlanie wyników
figure;
imshow(bim);
title('Obraz po etykietowaniu pozostałych obiektów');
% Zapisywanie obrazu
imwrite(bim, 'obraz_po_etykietowaniu.png');
