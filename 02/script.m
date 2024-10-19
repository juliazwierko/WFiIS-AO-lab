clear; clc; close all;

im = imread('zubr.jpg'); % uint 0-255, macierz: 642x1000x3(rgb)
%imshow(im); % wyswietl obrazek
im = double(im) / 255; % normalizacja poprzez rzutowania do double)
% imshow spodziewa sie albo 0 albo 1
imshow(im); 

% wyswietlenie wiecej niz 1 obrazek, otworzenie kolejnego obrazu w 
% nowym oknie:
% figure;
% imshow(im);

% podzial okna na obszary 
% indeksacja - wiersz po wierszu

% -------- Zubr RGB --------
h=2;
w=2;

% RGB
subplot(h,w,1)
imshow(im)

% warstwa czerwona - '1'
subplot(h,w,2)
r = im(:,:,1);
imshow(r);

% warstwa zielona - '2' 
subplot(h,w,3)
g = im(:,:,2);
imshow(g);

% warstwa niebieska - '3' 
subplot(h,w,4)
b = im(:,:,3);
imshow(b);
saveas(gcf, 'zubr_rgb.png');

% -------- Histogram --------
% Histogram to graficzna reprezentacja danych, 
% która pokazuje, jak często występują poszczególne 
% wartości w danym zbiorze.
figure;
h=3; w=2;

for i = 1:3
    image = im(:,:,i);
    subplot(h,w,2*i-1)
    imshow(image)

    subplot(h,w,2*i)
    imhist(image)
end

% -------- Odcieni szarosci --------
% Chcemy przekształcić obraz RGB (kolorowy) na obraz w skali szarości.
% Najprostszą metodą jest obliczenie średniej arytmetycznej trzech warstw (R, G, B),
% co można wykonać za pomocą funkcji rgb2gray(im) lub ręcznie, jak poniżej:

figure;
gray_image = mean(im, 3); % Obliczamy średnią wzdłuż 3 wymiaru (warstw R, G, B)
imshow(gray_image); % Wyświetlamy obraz w skali szarości
saveas(gcf, 'zubr_gray.png'); 

% Istnieją jednak inne metody konwersji, które można zastosować:
% - Zamiast średniej, możemy wziąć największą wartość (max) spośród warstw R, G, B.
% - Możemy również wziąć najmniejszą wartość (min) spośród tych trzech warstw.
% - Mediana (median) to inna funkcja, która zwraca środkową wartość z trzech warstw.
%
% Alternatywnie, można użyć średniej ważonej, przypisując różne wagi poszczególnym kolorom.
% Dla przykładu, ludzkie oko jest najbardziej czułe na kolor zielony, następnie czerwony,
% a najmniej na niebieski. Dlatego możemy nadać większą wagę kolorowi zielonemu.
%
% Taki sposób przekształcenia może być użyteczny np. w sytuacjach, gdy oświetlenie (np. światło słoneczne)
% ma wpływ na obraz i chcemy skupić się na najbardziej widocznych barwach.


figure;
% Standard YUV definiuje wagi dla każdego z kanałów kolorów RGB
% dla konwersji obrazu na luminancję (Y), czyli jasność.
% Wartości te odpowiadają wpływowi kolorów na ostateczną jasność obrazu:
% - .299 dla czerwonego (R)
% - .587 dla zielonego (G)
% - .144 dla niebieskiego (B)
YUV = [.299, .587, .144];

% Wektor YUV ma wymiary 1x3 (jeden wiersz i trzy kolumny).
% Aby poprawnie go wymnożyć z trzema warstwami obrazu RGB,
% musimy zmienić jego wymiary na 1x1x3. Robimy to za pomocą funkcji permute,
% która "obraca" wymiary tablicy, tak aby stał się wektorem 1x1x3.
YUV = permute(YUV, [1,3,2]);

% Teraz mnożymy każdą warstwę obrazu (R, G, B) przez odpowiednią wagę
% z wektora YUV, a następnie sumujemy wynik dla każdego piksela.
% To daje wynik w postaci luminancji, czyli jasności obrazu, zgodnie z YUV.
im_yuv = sum(im .* YUV,3);
imshow(im_yuv);
saveas(gcf, 'zubr_yuv.png'); 


% --------------- Przeksztalcenia obrazu ---------------
% W tym skrypcie dokonujemy trzech podstawowych przekształceń obrazu:
% 1. Jasność (Brightness) - dodanie stałej do wszystkich wartości pikseli.
% 2. Kontrast (Contrast) - skalowanie wartości pikseli.
% 3. Gamma - nieliniowa korekcja wartości pikseli.

% -------- JASNOŚĆ --------
figure;
b = 0.2;  % Dodajemy wartość do pikseli, aby zwiększyć jasność.
bim = gray_image + b;  % gray_image to obraz wejściowy w skali szarości.
bim(bim > 1) = 1;  % Jeśli piksel wyjdzie poza zakres 0-1, ustalamy maksymalnie 1.
bim(bim < 0) = 0;  % Jeśli piksel wyjdzie poza zakres 0-1, ustalamy minimalnie 0.

h = 2;
v = 3;
subplot(h,v,1);
imshow(bim);  % Wyświetlamy obraz po zmianie jasności.

subplot(h,v,2);
imhist(bim);  % Wyświetlamy histogram zmienionego obrazu.

subplot(h,v,4);
imshow(gray_image);  % Wyświetlamy oryginalny obraz.

subplot(h,v,5);
imhist(gray_image);  % Wyświetlamy histogram oryginalnego obrazu.

% Funkcja przekształcenia liniowego dla jasności.
x = 0:1/255:1;
y = x + b;
y(y > 1) = 1;
y(y < 0) = 0;

subplot(h,v,6);
plot(x,y);  % Rysujemy funkcję przekształcenia dla jasności.
ylim([0,1]);
saveas(gcf, 'zubr_brightness.png'); 
% -------- KONTRAST --------
figure;
c = 0.5;  % Skaluje wartości pikseli, aby zmienić kontrast.
cim = gray_image * c;
cim(cim > 1) = 1;  % Zakres pikseli po zmianie kontrastu.
cim(cim < 0) = 0;

subplot(h,v,1);
imshow(cim);  % Wyświetlamy obraz po zmianie kontrastu.

subplot(h,v,2);
imhist(cim);  % Wyświetlamy histogram zmienionego obrazu.

subplot(h,v,4);
imshow(gray_image);  % Wyświetlamy oryginalny obraz.

subplot(h,v,5);
imhist(gray_image);  % Wyświetlamy histogram oryginalnego obrazu.

% Funkcja przekształcenia liniowego dla kontrastu.
x = 0:1/255:1;
y = x * c;
y(y > 1) = 1;
y(y < 0) = 0;

subplot(h,v,6);
plot(x,y);  % Rysujemy funkcję przekształcenia dla kontrastu.
ylim([0,1]);
saveas(gcf, 'zubr_contrast.png'); 

% -------- GAMMA --------
figure;
gamma = 2;  % Wartość gamma - nieliniowa korekcja.
gamma_im = gray_image .^ (1/gamma);  % Zastosowanie korekcji gamma.

subplot(h,v,1);
imshow(gamma_im);  % Wyświetlamy obraz po korekcji gamma.

subplot(h,v,2);
imhist(gamma_im);  % Wyświetlamy histogram zmienionego obrazu.

subplot(h,v,4);
imshow(gray_image);  % Wyświetlamy oryginalny obraz.

subplot(h,v,5);
imhist(gray_image);  % Wyświetlamy histogram oryginalnego obrazu.

% Funkcja przekształcenia nieliniowego dla gamma.
x = 0:1/255:1;
y = x .^ gamma;  % Używamy potęgowania do korekcji gamma.
y(y > 1) = 1;  % Zakres pikseli po korekcji gamma.
y(y < 0) = 0;

subplot(h,v,6);
plot(x,y);  % Rysujemy funkcję przekształcenia dla gamma.
ylim([0,1]);

saveas(gcf, 'zubr_gamma.png'); 

% -------- Wyrownanie histogramu --------
figure;
him = histeq(im);

h=2; w=2;
subplot(h,w,1)
imshow(gray_image);
subplot(h,w,2)
imhist(im);
subplot(h,w,3)
imshow(bim)
subplot(h,w,4)
imhist(him);

saveas(gcf, 'zubr_hist_eq.png'); 