clear; clc; close all

% Wczytanie obrazu 'ptaki.jpg' i przygotowanie do przetwarzania
im = imread('ptaki.jpg');
h = 4; w = 2;

% Przekształcenie kanałów obrazu na obraz binarny (białe kaczki, czarne tło)
r = imbinarize(im(:,:,1));  % Binarizacja kanału czerwonego
b = imbinarize(im(:,:,3));  % Binarizacja kanału niebieskiego
bim = r | ~b;  % Połączenie obu kanałów (białe kaczki, czarne tło)

% Wyświetlenie początkowego obrazu binarnego
subplot(h, w, 1);
imshow(bim);
% Zapisanie obrazu binarnego
imwrite(bim, 'binarized_image.png');

% Otwarcie i zamknięcie obrazu binarnego w celu usunięcia szumów
bim = imopen(bim, ones(5));  % Otwarcie (usuwanie małych obiektów)
bim = imclose(bim, ones(5)); % Zamknięcie (wypełnianie małych dziur)

% Wyświetlenie obrazu po operacjach morfologicznych
subplot(h, w, 2);
imshow(bim);
% Zapisanie obrazu po operacjach morfologicznych
imwrite(bim, 'morphological_operations.png');

% Etykietowanie obiektów na obrazie binarnym
l = bwlabel(bim);  % Etykietowanie obiektów
n = max(l(:));     % Liczba obiektów

% Analiza właściwości obiektu o etykiecie 4
a = regionprops(l == 4, 'all');  % Pobranie wszystkich właściwości obiektu o etykiecie 4

% Wyświetlenie obrazu obiektu o etykiecie 4
subplot(h, w, 3);
imshow(a.Image);
% Zapisanie obrazu obiektu o etykiecie 4
imwrite(a.Image, 'object_label_4.png');

% Wyświetlenie etykietowanego obrazu obiektu o etykiecie 4
subplot(h, w, 4);
imshow(l == 4);
% Zapisanie etykietowanego obrazu obiektu o etykiecie 4
imwrite(l == 4, 'labeled_object_4.png');

% Rozważania dotyczące analizy strukturalnej:
% - Możemy wypełnić dziurę lub pozostawić ją niezmienioną, zależnie od tego, jak traktujemy parowane struktury.
% - "Perimeter" - możemy utworzyć ramkę wokół obiektu i policzyć jego piksele, aby uzyskać obwód.
% Więcej szczegółów na temat właściwości dostępnych w regionprops: 
% https://www.mathworks.com/help/images/ref/regionprops.html

% Przykładowe właściwości zwracane przez regionprops:
% - area: liczba pikseli w obiekcie
% - centroid: punkt centralny obiektu
% - boundingbox: najmniejszy prostokąt, w którym mieści się obiekt
% - major, minor axis: długości osi o największej i najmniejszej rozpiętości
% - eccentricity: rozkład masy obiektu względem środka
% - convexhull: wypukła powłoka obiektu, zbliżona do obwodu
% - euler: liczba obiektów w analizowanym regionie
% - perimeter: obwód obiektu
% - porównanie kształtu do koła - używane do analizy podobieństwa kształtu
% - circularity: miara podobieństwa obiektu do koła (współczynnik okrągłości)
% - inne właściwości, takie jak Malinowska, BralirBliss, Danielsson, Harolita, mogą służyć do zaawansowanej analizy kształtu i struktury obiektów.

% Zastosowanie funkcji do analizy kształtu i obliczania współczynników podobieństwa:
% Funkcje takie jak AO5RBlairBliss, AO5RDanielsson, AO5RFeret, AO5RHaralick, AO5RMalinowska obliczają różne współczynniki kształtu.
