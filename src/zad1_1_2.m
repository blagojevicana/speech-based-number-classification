clear
close all
clc


fs=8000; % najcesca ucestanost odabiranja
T=1/fs;
duration=20; % sekunde
N=duration*fs; % broj odbiraka
nbits=16; % broj bita za kodiranje
nchans=1; % broj kanala

%% Snimanje govorne sekvence
x=audiorecorder(fs,nbits,nchans);
disp('Start')
recordblocking(x,duration)
disp('End')


%% Reprodukcija
y=getaudiodata(x);
sound(y,fs) % podrazumevano fs=8192Hz, -1<y<1 klipovanje

%% Cuvanje
audiowrite('govorna_sekvenca_2.wav',y,fs)
%%

[y,fs]=audioread('govorna_sekvenca_2.wav');

figure(1)
plot(T:T:length(y)*T,y)
title('Snimljena govorna sekvenca')
xlabel('t[s]'); ylabel('y(t)')

y=y(0.13*fs:end);

Wn=[60 fs/2-100]/(fs/2);
[B,A]=butter(6,Wn,'bandpass');
yf=filter(B,A,y);


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
figure(2)
plot(time,yf,time,E)
title('Talasni oblik i kratkovremenska energija')
legend('sekvenca','energija')
xlabel('t[s]');

% prikaz talasnih oblika i ucestanost presecanja nule
figure(3)
plotyy(time,yf,time,Z)
title('Talasni oblik i kratkovremenski ZCR')
legend('sekvenca','ZCR')
xlabel('t[s]');
%%
T = 1/fs;
t = 0:T:(length(y)-1)*T;

ITU = max(E)*0.3;
ITL = max(E)*0.003;
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
figure(4)
plot(t,yf,t,rec*max(yf))
xlabel('t[s]');


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
rec = zeros(1,length(yf));
for i=1:length(pocetak)
    rec(pocetak(i):kraj(i)) = ones(1,kraj(i)-pocetak(i)+1);
end
figure(5)
plot(t,yf,t,rec*max(yf))
title('Segmentisane reci')
xlabel('t[s]');

%%
for i=1:length(pocetak)
    sound(y(pocetak(i):kraj(i)),fs)
    pause
end

%% teager
win=ones(1,fs*20e-3); % pravougaoni prozor
noverlap=(fs*20e-3)-1;
figure(6)
spectrogram(yf,win,noverlap,1024,'yaxis')

[S,F,T,P]=spectrogram(yf,win,noverlap,128*2,fs,'yaxis'); % Nf utice
%%
Te=zeros(size(T));
for t=1:length(T)
    Te(t)=sum(P(:,t).*F.^2);
end

figure(7)
% yyaxis left
% plot(time,E)
% yyaxis right
% plot(time,[zeros(1,length(win)-1) Te])
plot(time,E)
hold on
plot(time,[zeros(1,length(win)-1) Te])
legend('E','Te')







