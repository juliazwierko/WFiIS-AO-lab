clear; clc;
%  /opt/matlab/MATLAB_2022/bin/matlab


% -------- tworzenie sekwencji liczb --------
c = 1:10 
c = 1:2:10
c = 10:-1:0


% -------- macierze --------
a = [1,3,3;4,5,6] % typ danych - double
% macierz(rows, cols), indeksowanie od 1!
a(1,2) % wyciaganie elemntu z macierzy
a(2,[1,3]) % 2 wiersz, kolumna 1 i 3;
a(2,[1:3])
% end, jest przydatny kiedy nie wiemy wymiarow macierzy 
a(1,end) 
a(1,1:end)
a(1,:)
% wypisanie macierzy w calosci 
a(:, :)


% -------- indeksowanie --------
a = [1,2,3;4,5,6]
a(5) % 'idziemy' kolumnami!
a(4)
a(:) % ektor pionowy 6 elementow
% indeksowanie logiczne
a(a>2) % tez 'idziemy' kolumnami

a(a>2) = 11:14
a(a<2) = 0

% USUNIECIE kolumny zastepujemy pustym wektorem
a(:,2) = []


% -------- operacje matematyczne --------
% + dodawanie,
% – odejmowanie,
% * mnożenie,
% / dzielenie
% (dzielenie macierzy A przez B jest równoważne mnożeniu 
% A przez odwrotność B: A/B <=> A * B-1),
% ^ potęgowanie
% (podnoszenie macierzy A do potęgi np.: 2 jest równoważne
% obliczeniu A * A;
% podnoszenie macierzy A do potęgi np.: 1/2 jest równoważne
% obliczeniu sqrt(A)),
% ’ transpozycję.
a = [1,2,3,4,5,6]
b = [7,8,2,3,5,9]
a + b 
a - b
% a*b,  zle! wymiary sie nie zgadzaja!
a*b'% Transpozycja macierzy


% -------- operacje tablicowe --------
% .* mnożenie tablicowe,
% ./ dzielenie tablicowe,
% .^ potęgowanie tablicowe.
a.*b
a./b
a.^b
a*2
a+2


% -------- instrukcje sterujace --------
% if, else -> end
a = 3
if a > 2 
    a = 1;
    a
end


if a < 2
    a = 0;
    a
else
    a = 10;
    a
end

% while
while a < 5
    a = a + 2;
end
a % 0, 2, 4, (6)

%break, continue


% ----------------
%{
    blokowy komientarz
    test1
    test2
%}

% CTLR + R / + P -------> komientarze