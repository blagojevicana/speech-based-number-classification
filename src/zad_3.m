clear
close all
clc

fs=8000; 
T=1/fs;
duration=35; 
N=duration*fs; 
nbits=16; 
nchans=1; 

[y,fs]=audioread('treci_zad.wav');

figure(4)
plot(T:T:length(y)*T,y)
title('Snimljena govorna sekvenca')
xlabel('t[s]'); ylabel('y(t)')
ylim([-0.07 0.07])

y=y(0.19*fs:end);
[pocetak,kraj,yf]=preprocessing(y,fs);
rec = zeros(1,length(yf));
for i=1:length(pocetak)
    rec(pocetak(i):kraj(i)) = ones(1,kraj(i)-pocetak(i)+1);
end
t = 0:T:(length(y)-1)*T;
figure(3)
plot(t,yf,t,rec*max(yf))
title('Segmentisane reci')
xlabel('t[s]');
ylim([-0.07 0.1])

%%
[obelezje2,obelezje5,obelezje7]=feature_extraction(y,pocetak,kraj,fs);
figure(1)
plot(obelezje2(1,:),obelezje2(2,:),'bo')
hold on
plot(obelezje5(1,:),obelezje5(2,:),'gx')
hold on
plot(obelezje7(1,:),obelezje7(2,:),'r*')
legend('Dva','Pet','Sedam')
xlabel('Obelezje 1'); ylabel('Obelezje 2')
ylim([-0.7 0.1])
xlim([-1.7 -0.1])

%% Klasifikacija 
X1=obelezje5;
X2=obelezje7;
X3=obelezje2;
X1_new=[X1,X2];
X2_new=X3;
%X_test=[X1_test,X2_test,X3_test];
X_test=[X1 X2 X3];

%Y=[ones(1,200) 2*ones(1,200) 3*ones(1,200)];
Y=[ones(1,10), 2*ones(1,10), 3*ones(1,10)];

[s_opt,v0_opt,Neps_opt,M1_est,M2_est,S1_est,S2_est]=druga_numericka_metoda(X1_new,X2_new);
V1=(s_opt*S1_est+(1-s_opt)*S2_est)^(-1)*(M2_est-M1_est);
v01=v0_opt;

x1=-10:0.1:2.3; 
x2=-(v01+V1(1)*x1)/V1(2);

figure(1)
hold on
plot(x1,x2,'k')

% 
Y_test=V1'*X_test+v01;
Y_test(Y_test>0)=3;
indeksi=find(Y_test<0);

X1_new=X1;
X2_new=X2;
[s_opt,v0_opt,Neps_opt,M1_est,M2_est,S1_est,S2_est]=druga_numericka_metoda(X1_new,X2_new);
V2=(s_opt*S1_est+(1-s_opt)*S2_est)^(-1)*(M2_est-M1_est);
v02=v0_opt;

x1=-3.6:0.1:15; 
x2=-(v02+V2(1)*x1)/V2(2);

plot(x1,x2,'k')
legend('Dva','Pet','Sedam')


if ~isempty(indeksi) 
    Y_test(indeksi)=V2'*X_test(:,indeksi)+v02;
    Y_test(Y_test<0)=1;
    Y_test((Y_test~=1)&(Y_test~=3))=2;
end

confusionmat(Y,Y_test) % sedam dva pet

%%
Y=[ 3 1 2 3 1 2 3 1 2 3 1 2 3 1 2 ]; 
Yt=[];
for i=1:15
    X_test=cifer_recognition(V1,v01,V2,v02);
    Y_test=V1'*X_test+v01;
    Y_test(Y_test>0)=3;
    indeksi=find(Y_test<0);

    if ~isempty(indeksi) 
        Y_test(indeksi)=V2'*X_test(:,indeksi)+v02;
        Y_test(Y_test<0)=1;
        Y_test((Y_test~=1)&(Y_test~=3))=2;
    end
    figure(1)
    hold on
    if mod(i,3)==1
        plot(X_test(1),X_test(2),'b.','MarkerSize',15)
    elseif mod(i,3)==2
        plot(X_test(1),X_test(2),'g.','MarkerSize',15)
    else
        plot(X_test(1),X_test(2),'r.','MarkerSize',15)
    end
    Yt=[Yt Y_test];
%     if Y_test==1
%         disp('Pet')
%     elseif Y_test==2
%         disp('Sedam')
%     else
%         disp('Dva')
%     end
    pause
end
confusionmat(Y,Yt)
figure(1)
title('Testiranje klasifikacije')
xlabel('Obelezje 1')
ylabel('Obelezje 2')
legend('Dva','Pet','Sedam')

% X_test=cifer_recognition();
% Y_test=V1'*X_test+v01;
% Y_test(Y_test>0)=3;
% indeksi=find(Y_test<0);
% 
% if ~isempty(indeksi) 
%     Y_test(indeksi)=V2'*X_test(:,indeksi)+v02;
%     Y_test(Y_test<0)=1;
%     Y_test((Y_test~=1)&(Y_test~=3))=2;
% end
% if Y_test==1
%     disp('Pet')
% elseif Y_test==2
%     disp('Sedam')
% else
%     disp('Dva')
% end
% figure(1)
% hold on
% plot(X_test(1),X_test(2),'b.','MarkerSize',15)
% ylim([-0.7 0.6])
