function [pocetak,kraj,yf]=preprocessing(y,fs)
T=1/fs;
Wn=[60 fs/2-100]/(fs/2);
[B,A]=butter(6,Wn,'bandpass');
yf=filter(B,A,y);
figure(5)
plot(T:T:length(y)*T,y)
hold on
plot(T:T:length(yf)*T,yf)
title('Filtrirana govorna sekvenca')
xlabel('t[s]'); ylabel('y(t)')
ylim([-0.07 0.07])
legend('original','filtrirana')

wl=fs*20e-3;
E=zeros(size(yf)); % energija
Z=zeros(size(yf)); % brzina prolaska kroz nulu
for i=wl:length(yf)
    rng=(i-wl+1):i-1;
    E(i)=sum(yf(rng).^2);
    Z(i)=sum(abs(sign(yf(rng+1))-sign(yf(rng)))); % broj promena znaka
end
Z=Z/2/wl; % delimo sa wl da ne bi zavisilo od velicine prozora

time=T:T:length(E)*T;


% prikaz talasnih oblika i kratkorocne energije


% prikaz talasnih oblika i ucestanost presecanja nule

%
T = 1/fs;
t = 0:T:(length(y)-1)*T;

ITU = max(E)*0.04;
ITL = max(E)*0.001;
pocetak = [];
kraj = [];

for i=2:length(E)
    if(E(i-1)<ITU && E(i)>ITU)
        pocetak = [pocetak i];
    end
end

for i=1:length(E)-1
    if(E(i)>ITU && E(i+1)<ITU)
        kraj = [kraj i];
    end
end

rec = zeros(1,length(yf));
for i=1:length(pocetak)
    rec(pocetak(i):kraj(i)) = ones(1,kraj(i)-pocetak(i)+1);
end


% Potencijalno prosirenje reci

for i=1:length(pocetak)
    while(E(pocetak(i))>ITL)
        pocetak(i) = pocetak(i)-1;
    end
    while(E(kraj(i))>ITL)
        kraj(i) = kraj(i)+1;
    end
end
pocetak = unique(pocetak);
kraj = unique(kraj);
end