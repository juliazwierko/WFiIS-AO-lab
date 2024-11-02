clear; clc; close all;

% Wczytanie obrazu i konwersja do skali szarości
im = rgb2gray(double(imread('opera.jpg')) / 255); % Normalizacja obrazu

% Transformacja Fouriera - przekształcenie obrazu do dziedziny częstotliwości
fim = fft2(im); % macierz liczb zespolonych

% Ekstrakcja amplitudy i fazy
A = abs(fim); % Amplituda - energia w każdej częstotliwości
phi = angle(fim); % Faza - informacje o przesunięciach fazowych

% Zapisanie amplitudy w skali logarytmicznej
imwrite(log(A + 1), 'amplituda_log.png'); % Dodanie +1, aby uniknąć log(0)

% Rekonstrukcja obrazu z amplitudy i fazy
z = A .* exp(1i * phi); % Przywracanie zespolonego sygnału
im2 = abs(ifft2(z)); % Przekształcenie odwrotne do dziedziny przestrzennej

% Wyświetlenie zrekonstruowanego obrazu i zapisanie go
figure;
imshow(im2);
title('Rekonstruowany obraz');
imwrite(im2, 'rekonstruowany_obraz.png');

% Filtr dolnoprzepustowy
k = 7; % Rozmiar filtra
f = ones(k) / k^2; % Uśredniający filtr przestrzenny
[h, w] = size(im); % Rozmiar oryginalnego obrazu
ff = fft2(f, h, w); % Transformacja Fouriera filtra

% Aplikacja filtra na obraz w dziedzinie częstotliwości
zc = A .* abs(ff) .* exp(1i * phi); % Modyfikacja amplitudy z użyciem filtra
imz = ifft2(zc); % Rekonstrukcja obrazu po filtracji
imz = abs(imz); % Użycie wartości bezwzględnej dla końcowego obrazu
figure;
imshow(imz); % Wyświetlenie przefiltrowanego obrazu
imwrite(imz, 'przefiltrowany_obraz.png'); % Zapisanie przefiltrowanego obrazu

% Użycie maski do kompresji obrazu
k = 50; % Rozmiar maski
m = zeros(h, w); % Macierz zer (cały czarny obraz)
m([1:k, end-k:end], [1:k, end-k:end]) = 1; % Tworzenie maski kwadratowej w rogach
figure;
imshow(m); % Wyświetlenie maski
imwrite(m, 'mask.png'); % Zapisanie maski

% Aplikacja maski na amplitudę obrazu
z = m .* A .* exp(1i * phi); % Nałożenie maski na amplitudę
figure;
imshow(ifft2(z)); % Wyświetlenie obrazu po nałożeniu maski
imwrite(abs(ifft2(z)), 'obraz_po_maskowaniu.png'); % Zapisanie obrazu po maskowaniu
