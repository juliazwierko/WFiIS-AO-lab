% metoda Cramera 
clear; clc;
a = [1,2,3,4; 4,9,16,25; 1,7,2,3; 2,3,5,7]
b = (1:4)'
da =det(a)
for i=1:4
    ta = a;
    ta(:,i)=b
    x(i)=det(ta)/da
end
x