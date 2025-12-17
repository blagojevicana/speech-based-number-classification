function [S]=sigma(X1)
N1=length(X1(1,:));
M1_est=sum(X1')/N1;
M1_est=M1_est';
S1_est=zeros(2,2);
for i=1:N1
    S1_est=S1_est+(X1(:,i)-M1_est)*(X1(:,i)-M1_est)';
end
S1_est=S1_est/N1;
S=S1_est;
end