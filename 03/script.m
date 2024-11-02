% -------- Zubr RGB --------
clear; clc; clf; close all;  % Clear workspace, command window, figures, and close all open windows

% Wczytanie obrazu i przekształcenie do skali szarości
im = imread('zubr.jpg');  % Wczytaj obraz
im = double(im) / 255;     % Przekształć do formatu double i normalizuj wartości do zakresu [0, 1]
im = rgb2gray(im);         % Przekształć obraz RGB do skali szarości
% imshow(im);  % Wyświetlenie obrazu (zakomentowane)

% Opis sąsiedztwa pikseli
% Piksele sąsiadujące, jeśli mają co najmniej jeden wspólny wierzchołek
% Możemy patrzeć na sąsiedztwo:
% - krawędź (von Neumann)
% - wierzchołek (Moore)

% Wybór rzędu sąsiedztwa - np. 2 rząd sąsiedzi sąsiada

% Filtry - Filtr uśredniający (Blur)
% Zastosowania:
%   - Usuwanie niepożądanych ekstremów
%   - Usuwanie białych pikseli/kropelek w obrazie
%   - Odszumianie obrazu

k = 33;  % Rozmiar filtru
f = ones(k) / k^2;  % Filtr uśredniający - rozmycie obrazu
% Obliczenie wartości dla filtru
% Uśredniamy wartości pikseli, co powoduje efekt rozmycia (blur)
fim = imfilter(im, f);  % Zastosowanie filtru do obrazu

% Wyświetlenie oryginalnego obrazu i obrazu po filtracji
h = 1; w = 2;
subplot(h, w, 1)  
imshow(im)  % Oryginalny obraz
title("Oryginalny obraz")  % Tytuł
saveas(gcf, 'oryginalny_obraz.png');  % Zapisz oryginalny obraz

subplot(h, w, 2)  
imshow(fim)  % Obraz po filtracji
title("Obraz po filtracji - Blur")  % Tytuł
saveas(gcf, 'obraz_po_filtracji_blur.png');  % Zapisz obraz po filtracji

% ======= Różne wagi =======
k = 3;  % Rozmiar filtru
% f = ones(k) / k^2;  % Opcjonalne - filtr uśredniający
f = [1 2 1; 2 4 2; 1 2 1] / 16;  % Filtr z różnymi wagami - Gaussian blur
fim = imfilter(im, f);  % Zastosowanie filtru do obrazu

% Wyświetlenie oryginalnego obrazu i obrazu po filtracji
figure;  % Nowa figura
h = 1; w = 2;
subplot(h, w, 1)
imshow(im)  % Oryginalny obraz
title("Oryginalny obraz")  % Tytuł
saveas(gcf, 'oryginalny_obraz_gaussian.png');  % Zapisz oryginalny obraz

subplot(h, w, 2)
imshow(fim)  % Obraz po filtracji
title("Obraz po filtracji - Gaussian Blur")  % Tytuł
saveas(gcf, 'obraz_po_filtracji_gaussian.png');  % Zapisz obraz po filtracji

% Rozmywanie w kierunku pionowym
f = [0 0 0; 2 4 2; 0 0 0] / 8;  % Filtr rozmywający w kierunku pionowym
fim = imfilter(im, f);  % Zastosowanie filtru do obrazu

% Wyświetlenie oryginalnego obrazu i obrazu po rozmyciu
figure;
h = 1; w = 2;
subplot(h, w, 1)
imshow(im)  % Oryginalny obraz
title("Oryginalny obraz")  % Tytuł
saveas(gcf, 'oryginalny_obraz_vanishing.png');  % Zapisz oryginalny obraz

subplot(h, w, 2)
imshow(fim)  % Obraz po rozmyciu
title("Rozmycie w pionie")  % Tytuł
saveas(gcf, 'rozmycie_w_pionie.png');  % Zapisz obraz po rozmyciu

% Użycie wag ujemnych do uwypuklenia różnic na obrazie
figure;
k = 3;  % Rozmiar filtru
f = -ones(k);  % Wagi ujemne
f((k + 1) / 2, (k + 1) / 2) = k^2;  % Ustalenie wartości centralnej
fim = imfilter(im, f);  % Zastosowanie filtru do obrazu

% Wyświetlenie oryginalnego obrazu i obrazu po filtracji
h = 1; w = 2;
subplot(h, w, 1)
imshow(im)  % Oryginalny obraz
title("Oryginalny obraz")  % Tytuł
saveas(gcf, 'oryginalny_obraz_neg_weights.png');  % Zapisz oryginalny obraz

subplot(h, w, 2)
imshow(fim)  % Obraz po filtracji
title("Wagi ujemne - uwypuklenie różnic")  % Tytuł
saveas(gcf, 'uwypuklenie_roznic.png');  % Zapisz obraz po filtracji

% Filtr krawędziowy - suma wag = 0
figure;
f = -ones(k);  % Wagi ujemne
f((k + 1) / 2, (k + 1) / 2) = k^2 - 1;  % Ustalenie wartości centralnej
fim = imfilter(im, f);  % Zastosowanie filtru do obrazu

% Wyświetlenie oryginalnego obrazu i obrazu po filtracji
h = 1; w = 2;
subplot(h, w, 1)
imshow(im)  % Oryginalny obraz
title("Oryginalny obraz")  % Tytuł
saveas(gcf, 'oryginalny_obraz_edge_filter.png');  % Zapisz oryginalny obraz

subplot(h, w, 2)
imshow(fim)  % Obraz po filtracji
title("Filtr krawędziowy - uwypuklenie krawędzi")  % Tytuł
saveas(gcf, 'uwypuklenie_krawedzi.png');  % Zapisz obraz po filtracji

% Filtr medianowy - dobra metoda do odszumiania
k = 3;  % Rozmiar filtru
figure;
fim = medfilt2(im, [k, k]);  % Zastosowanie filtru medianowego
imshow(fim)
title("Filtr medianowy - odszumianie")  % Tytuł
saveas(gcf, 'filtr_medianowy.png');  % Zapisz obraz po filtracji

%% Binaryzacja
% Konwersja obrazu na obraz binarny
figure;
bim = im;  % Skopiowanie obrazu
bim(bim < .5)  = 0;  % Ustawienie pikseli poniżej 0.5 na 0
bim(bim >= .5) = 1;  % Ustawienie pikseli powyżej lub równo 0.5 na 1

h = 1; w = 1;
subplot(h, w, 1)
imshow(bim)  % Wyświetlenie obrazu binarnego
title("Binaryzacja - prog 0.5")  % Tytuł
saveas(gcf, 'binaryzacja_prog_0_5.png');  % Zapisz obraz po binaryzacji

% Inna wartość progowa
figure;
bim = im;  % Skopiowanie obrazu
t = 0.6;  % Nowa wartość progu
bim(bim < t)  = 0;  % Ustawienie pikseli poniżej progu na 0
bim(bim >= t) = 1;  % Ustawienie pikseli powyżej lub równo progowi na 1

h = 1; w = 1;
subplot(h, w, 1)
imshow(bim)  % Wyświetlenie obrazu binarnego
title("Binaryzacja - prog 0.6")  % Tytuł
saveas(gcf, 'binaryzacja_prog_0_6.png');  % Zapisz obraz po binaryzacji

% Sprawdzenie struktury obrazu binarnego
% W celu zrozumienia, jak wygląda zrzut obrazu binarnego
figure; 
h = 1; w = 2;
subplot(h, w, 1)
imshow(im)  % Oryginalny obraz
title("Oryginalny obraz")  % Tytuł
saveas(gcf, 'oryginalny_obraz_struct.png');  % Zapisz oryginalny obraz

subplot(h, w, 2)
imshow(bim)  % Obraz binarny
title("Obraz binarny")  % Tytuł
saveas(gcf, 'obraz_binarne_struct.png');  % Zapisz obraz binarny
