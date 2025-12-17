clear
close all
clc
%
fs=8000; % najcesca ucestanost odabiranja
T=1/fs;
duration=5; % sekunde
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
audiowrite('sekvenca_za_odredjivanje_pitch_periode.wav',y,fs)
%%

[y,fs]=audioread('sekvenca_za_odredjivanje_pitch_periode.wav');

% - Vizuelizacija signala
figure(1)
t=0:1/fs:(length(y)-1)/fs;
plot(t,y)
xlabel('t[s]'); ylabel('y(t)')
title('Sekvenca')
ylim([-0.04 0.04])

start_time=0.7*fs;
y=y(start_time:2.5*fs);


% ♥ Filtriranje signala
wn=[60 300]/(fs/2);
[b,a]=butter(6,wn,'bandpass');

yf=filter(b,a,y);
figure(2)
plot(0:1/fs:(length(yf)-1)/fs,yf)
xlabel('t[s]');ylabel('y(t)')
title('Sekvenca - filtrirana')

% ♥ Formiranje sekvenci 
[m1,m2,m3,m4,m5,m6]=formiranje_sekvenci(yf);
n=1:500;
figure(3)
subplot(3,1,1)
stem(n,yf(n)); xlabel('n[odb]'); ylabel('y[n]');
subplot(3,1,2)
stem(n,m1(n));  xlabel('n[odb]'); ylabel('m_1');
subplot(3,1,3); 
stem(n,m2(n));  xlabel('n[odb]'); ylabel('m_2');
figure(4)
subplot(4,1,1)
stem(n,m3(n));  xlabel('n[odb]'); ylabel('m_3');
subplot(4,1,2)
stem(n,m4(n));  xlabel('n[odb]'); ylabel('m_4');
subplot(4,1,3)
stem(n,m5(n));  xlabel('n[odb]'); ylabel('m_5');
subplot(4,1,4)
stem(n,m6(n));  xlabel('n[odb]'); ylabel('m_6');

[p1,p2,p3,p4,p5,p6,p]=procena_periode(fs,length(yf),m1,m2,m3,m4,m5,m6);
figure(5)
hold on
plot(1./p,'LineWidth',1.5)
title('Procena pitch frekvencije')
ylabel('f[Hz]')

% Finalno resenje
disp(1/median(p))
disp(median(pitch(yf,fs)))

%% Druga metoda - autokorelaciona fja
CL=0.3*max(abs(y));
y_clip=zeros(1,length(y));
for i=1:length(y)
    if y(i)>CL
        y_clip(i)=1;
    elseif y(i)<-CL
        y_clip(i)=-1;
    end
end
figure(6)
plot(y)
hold on
plot(y_clip*max(y))
title('Three-level klipovanje')
xlabel('t[s]'); ylabel('y(t)')

%
p=150;
N=length(y_clip);
rxx=zeros(2*p+1,1);
for k=(p+1):(2*p+1)
    rxx(k)=sum(conj(y_clip(1:(N-k+p+1))).*y_clip((1+k-(p+1)):N))/N;
end
rxx(p:-1:1)=conj(rxx(p+2:end));

figure(7)
plot(rxx(round(length(rxx)/2):end))
disp(fs/45) % 45 nadjeno rucno
title('Autokorelaciona funkcija')
xlabel('k[odb]'); ylabel('r_x_x[k]')


figure(8)
plot(y,y_clip,'*')
xlabel('y')
ylabel('y_c_l_i_p')
title('Three-level clipping')













