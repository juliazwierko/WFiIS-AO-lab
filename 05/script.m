clear; clc; close all;

% Wczytanie obrazu w odcieniach szarości i normalizacja do zakresu [0,1]
im = rgb2gray(double(imread('kaczki.jpg')) / 255);

% Binarizacja i operacja zamykania (dylatacja i erozja w celu poprawy kształtu obiektów)
bim = ~imbinarize(im); 
bim = imclose(bim, ones(11)); 

% Przygotowanie figure i parametrów subplotów
figure
h = 4; % Liczba wierszy subplotów
w = 5; % Liczba kolumn subplotów

% 1. Oryginalny obraz
subplot(h, w, 1);
imshow("kaczki.jpg");
title('Oryginalny obraz');
imwrite(imread('kaczki.jpg'), '01_oryginalny_obraz.png');

% 2. Obraz po binarizacji i operacji zamykania
subplot(h, w, 2);
imshow(bim);
title('Obraz binarny po zamknięciu');
imwrite(bim, '02_obraz_binarny_po_zamknieciu.png');

% Szkieletowanie obrazu binarnego
sk = bwmorph(bim, 'skel', inf); % Tworzenie szkieletu obiektów
subplot(h, w, 3);
imshow(sk);
title('Szkielet obrazu');
imwrite(sk, '03_szkielet_obrazu.png');

% Znajdowanie punktów końcowych na szkielecie
pt_end = bwmorph(sk, 'endpoint');
subplot(h, w, 4);
imshow(pt_end);
title('Punkty końcowe szkieletu');
imwrite(pt_end, '04_punkty_koncowe_szkieletu.png');

% Znajdowanie punktów rozgałęzień na szkielecie
pt_branch = bwmorph(sk, 'branchpoint');
subplot(h, w, 5);
imshow(pt_branch);
title('Punkty rozgałęzień szkieletu');
imwrite(pt_branch, '05_punkty_rozgalezien_szkieletu.png');

% Skurczanie obiektów (shrink) - redukcja do jednego piksela
sk_shrink = bwmorph(bim, 'shrink', 10); 
subplot(h, w, 6);
imshow(sk_shrink);
title('Skurcz obiektów');
imwrite(sk_shrink, '06_skurcz_obiektow.png');

% Cienkowanie obrazu (thin) - redukcja obiektów do linii o grubości 1 piksela
sk_thin = bwmorph(bim, 'thin', inf);
subplot(h, w, 7);
imshow(sk_thin);
title('Cienkowanie obiektów');
imwrite(sk_thin, '07_cienkowanie_obiektow.png');

% Pogrubianie obiektów (thicken)
sk_thicken = bwmorph(bim, 'thicken', 60);
subplot(h, w, 8);
imshow(sk_thicken);
title('Pogrubianie obiektów');
imwrite(sk_thicken, '08_pogrubianie_obiektow.png');

% Segmentacja - etykietowanie obiektów
labeled = bwlabel(bim);
subplot(h, w, 9);
imshow(label2rgb(labeled));
title('Segmentacja - etykiety obiektów');
imwrite(label2rgb(labeled), '09_segmentacja_etykiety_obiektow.png');

% Wyświetlenie konkretnego obiektu (np. obiekt nr 2)
subplot(h, w, 10);
imshow(label2rgb(labeled == 2));
title('Wyświetlenie obiektu nr 2');
imwrite(label2rgb(labeled == 2), '10_obiekt_nr_2.png');

% Transformata odległościowa
dist_transform = bwdist(bim); 
subplot(h, w, 11);
imshow(dist_transform, [0, max(dist_transform(:))]);
title('Transformata odległościowa');
imwrite(mat2gray(dist_transform), '11_transformata_odleglosciowa.png');

% Dodanie granic do obrazu binarnego (dla transformacji wododziałowej)
bim([1, end], :) = 1;
bim(:, [1, end]) = 1;

% Transformata odległościowa z metryką "chessboard"
dist_chessboard = bwdist(bim, 'chessboard');
subplot(h, w, 12);
imshow(dist_chessboard, [0, max(dist_chessboard(:))]);
title('Transformata odległościowa - chessboard');
imwrite(mat2gray(dist_chessboard), '12_transformata_chessboard.png');

% Wododział (watershed)
watershed_labels = watershed(dist_transform);
subplot(h, w, 13);
imshow(label2rgb(watershed_labels));
title('Segmentacja - wododział');
imwrite(label2rgb(watershed_labels), '13_wododzial.png');

% Zastosowanie segmentacji do obrazu oryginalnego
final_segmented = (watershed_labels == 2) .* bim .* im; 
subplot(h, w, 14);
imshow(final_segmented);
title('Segmentacja obiektu na obrazie oryginalnym');
imwrite(final_segmented, '14_segmentacja_na_oryginalnym.png');

% Wyświetlenie liczby kaczek (liczba obiektów)
n_objects = max(labeled(:));
disp(['Liczba kaczek (obiektów): ', num2str(n_objects)]);
