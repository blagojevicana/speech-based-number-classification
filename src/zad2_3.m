clear
close all
clc

[x,fs]=audioread('govorna_sekvenca_1.wav');
t=0:1/fs:(length(x)-1)/fs;
L=length(t);
for i=1:length(x)
    if x(i)<0.2*max(x) & x(i)>-0.2*max(x)
        x(i)=0;
    end
end

% Parametri
Q=0.007; % fiksan korak kvantizacije
xmean=mean(x); % srednja vrednost signala

% Pocetni uslovi
d=zeros(1,L); % prirastaj
d(1)=x(1);
c=zeros(1,L); % kodna rec
dd=zeros(1,L); % kvantizaovani prirastaj
dd(1)=Q;
xx=zeros(1,L); % rekonstruisani signal
xx(1)=xmean+dd(1);

% Delta modulacija
for i=2:L
    d(i)=x(i)-xx(i-1); % predikcija[n]=a*xx(n-1), a=1
    if d(i)>0
        c(i)=1;
        dd(i)=Q;
    else
        c(i)=0;
        dd(i)=-Q;
    end
    xx(i)=xx(i-1)+dd(i);

end

figure(1)
plot(x)
hold on
plot(xx)
title(sprintf('\\Delta=%.3f', Q))
xlabel('t[s]')


figure(2)
hist(d)
title('Histogram prirastaja')

%
figure(3)
plot(x)
hold on
plot(x,'*')
plot(xx,'x')
hold on
plot([0 xx(1:(L-1))],'o')
title(sprintf('\\Delta=%.3f', Q))
xlim([10000 10050])

legend('Originalni signal','Semplovani signal','Rekonstrukcija','Predikcija')



















