function [obelezje2,obelezje5,obelezje7]=feature_extraction(y,pocetak,kraj,fs)

obelezje=zeros(2,27);

for i=1:length(pocetak)
    rec=y(pocetak(i):kraj(i));
    win=20e-3*fs;
    p=14;
    k=1;
    for j=1:win:(length(rec)-win)
        LPC(:,k)=aryule(rec(j:(j+win-1)),p);
        k=k+1;
    end
%     figure()
%     subplot(2,1,1)
%     hold all
%     for m=2:8
%         hold all
%         plot(LPC(m,:))
%     end
%     legend('a1','a2','a3','a4','a5','a6','a7')
%     subplot(2,1,2)
%     hold all
%     for m=9:(p+1)
%         hold all
%         plot(LPC(m,:))
%     end
%     legend('a8','a9','a10','a11','a12','a13','a14')
    LPC_median=mean(LPC');
    obelezje(1,i)=LPC_median(2);
    obelezje(2,i)=LPC_median(4);
end
%
obelezje2=[];
obelezje5=[];
obelezje7=[];
for i=1:30
   if mod(i,3)==1
       obelezje2=[obelezje2 obelezje(:,i)];
   elseif mod(i,3)==2
       obelezje5=[obelezje5 obelezje(:,i)];
   else
       obelezje7=[obelezje7 obelezje(:,i)];
   end
end
% obelezje2=[obelezje(:,1),obelezje(:,4),obelezje(:,6),obelezje(:,9),obelezje(:,12),obelezje(:,15),obelezje(:,18),obelezje(:,21),obelezje(:,24),obelezje(:,27)];
% obelezje5=[obelezje(:,2),obelezje(:,5),obelezje(:,7),obelezje(:,10),obelezje(:,13),obelezje(:,16),obelezje(:,19),obelezje(:,22),obelezje(:,25)];
% obelezje7=[obelezje(:,3),obelezje(:,8),obelezje(:,11),obelezje(:,14),obelezje(:,17),obelezje(:,20),obelezje(:,23),obelezje(:,26)];


end