clear 
close all
clc

[y,Fs]=audioread('govorna_sekvenca_2.wav');
fs=8000;
y=y(0.13*fs:end);
Wn=[60 fs/2-100]/(fs/2);
[B,A]=butter(6,Wn,'bandpass');
yf=filter(B,A,y);
y=yf;

b=4; %broj bita, 8 i 12
x=y;
N=length(x); %duizina signala
M=2^b; %broj kvant. nivoa
d= 2*max(abs(x))/M; %duizina kvantizacionog nivoa (delta*M=2xmax)
xmax=max(abs(x));

for b=[4,8,12]
    figure()
    mi=100;
    a=0.1:0.01:1;
    M=2^b;
    d=2*xmax/M;
    SNR= [];
    xvar=[];
    for i=1:length(a)
        x1=a(i)*x;
        x_comp=xmax*log10(1+mi*abs(x1)/xmax)/log10(1+mi).*sign(x1);
        xq_mi=round(x_comp/d)*d;
        xq_mi(x_comp>(M-1)/2*d)=(M/2-1)*d;
        x_mi_decomp=1/mi*sign(xq_mi).*((1+mi).^(abs(xq_mi)/xmax)-1)*xmax;
        xvar= [xvar, var(x1)];
        SNR=[SNR, 10*log10(var(x1)/var(x1-x_mi_decomp))];
    end

    plot(xmax./sqrt(xvar),SNR) %log osa
    grid on
    set(gca,'xscale','log')
    xlabel('x_m_a_x/\sigma_x');
    ylabel('SNR');
    hold on
    
    mi=500;
    a=0.1:0.01:1;
    M=2^b;
    d=2*xmax/M;
    SNR= [];
    xvar=[];
    for i=1:length(a)
        x1=a(i)*x;
        x_comp=xmax*log10(1+mi*abs(x1)/xmax)/log10(1+mi).*sign(x1);
        xq_mi=round(x_comp/d)*d;
        xq_mi(x_comp>(M-1)/2*d)=(M/2-1)*d;
        x_mi_decomp=1/mi*sign(xq_mi).*((1+mi).^(abs(xq_mi)/xmax)-1)*xmax;
        xvar= [xvar, var(x1)];
        SNR=[SNR, 10*log10(var(x1)/var(x1-x_mi_decomp))];
    end

    plot(xmax./sqrt(xvar),SNR) %log osa
    grid on
    set(gca,'xscale','log')
    xlabel('x_m_a_x/\sigma_x');
    ylabel('SNR');
    legend('\mu=100','\mu=500')
end

figure(1)
title('4 bita')
figure(2)
title('8 bita')
figure(3)
title('12 bita')

for mi=[100 500]
    figure()
    b=4;
    a=0.1:0.01:1;
    M=2^b;
    d=2*xmax/M;
    SNR= [];
    xvar=[];
    for i=1:length(a)
        x1=a(i)*x;
        x_comp=xmax*log10(1+mi*abs(x1)/xmax)/log10(1+mi).*sign(x1);
        xq_mi=round(x_comp/d)*d;
        xq_mi(x_comp>(M-1)/2*d)=(M/2-1)*d;
        x_mi_decomp=1/mi*sign(xq_mi).*((1+mi).^(abs(xq_mi)/xmax)-1)*xmax;
        xvar= [xvar, var(x1)];
        SNR=[SNR, 10*log10(var(x1)/var(x1-x_mi_decomp))];
    end

    plot(xmax./sqrt(xvar),SNR) %log osa
    grid on
    set(gca,'xscale','log')
    xlabel('x_m_a_x/\sigma_x');
    ylabel('SNR');
    hold on
    
    b=8;
    a=0.1:0.01:1;
    M=2^b;
    d=2*xmax/M;
    SNR= [];
    xvar=[];
    for i=1:length(a)
        x1=a(i)*x;
        x_comp=xmax*log10(1+mi*abs(x1)/xmax)/log10(1+mi).*sign(x1);
        xq_mi=round(x_comp/d)*d;
        xq_mi(x_comp>(M-1)/2*d)=(M/2-1)*d;
        x_mi_decomp=1/mi*sign(xq_mi).*((1+mi).^(abs(xq_mi)/xmax)-1)*xmax;
        xvar= [xvar, var(x1)];
        SNR=[SNR, 10*log10(var(x1)/var(x1-x_mi_decomp))];
    end

    plot(xmax./sqrt(xvar),SNR) %log osa
    grid on
    set(gca,'xscale','log')
    ylabel('SNR');
    
    b=12;
    a=0.1:0.01:1;
    M=2^b;
    d=2*xmax/M;
    SNR= [];
    xvar=[];
    for i=1:length(a)
        x1=a(i)*x;
        x_comp=xmax*log10(1+mi*abs(x1)/xmax)/log10(1+mi).*sign(x1);
        xq_mi=round(x_comp/d)*d;
        xq_mi(x_comp>(M-1)/2*d)=(M/2-1)*d;
        x_mi_decomp=1/mi*sign(xq_mi).*((1+mi).^(abs(xq_mi)/xmax)-1)*xmax;
        xvar= [xvar, var(x1)];
        SNR=[SNR, 10*log10(var(x1)/var(x1-x_mi_decomp))];
    end

    plot(xmax./sqrt(xvar),SNR) %log osa
    grid on
    set(gca,'xscale','log')
    xlabel('x_m_a_x/\sigma_x');
    ylabel('SNR');
end

figure(4)
title('\mu=100')
legend('b=4','b=8','b=12')

figure(5)
title('\mu=500')
legend('b=4','b=8','b=12')


figure(6)
plot(0:1/fs:(length(yf)-1)/fs,yf)
title('Govorna sekvenca')
xlabel('t[s]'); ylabel('y(t)')








