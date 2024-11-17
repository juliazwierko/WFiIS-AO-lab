clear;clc;close all;
im=imread('ptaki.jpg');


imr=imbinarize(im(:,:,1));
imr1=imbinarize(im(:,:,3));
im=~imr1|imr;
im=imclose(im,ones(15));
l=bwlabel(im);
n=max(l,[],'all');
prep=regionprops(l==4,'all');


a=regionprops(im,'all');
a(1).Image;
a = regionprops(im,'all');
fun =  {@AO5RBlairBliss, @AO5RDanielsson, @AO5RFeret, @AO5RHaralick, @AO5RMalinowska};
w = zeros(length(a), length(fun));
for i =1:length(a)
    for j = 1:length(fun)
        w(i,j) =  fun{j}(a(i).Image);
    end
end

m=mean(w);
s=std(w);
out=abs(w-m)./s>1.8;

out=max(out,[],2);
w(out,:)=[];