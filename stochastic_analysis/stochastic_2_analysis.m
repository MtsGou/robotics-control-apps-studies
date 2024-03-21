clear all
clc

%GERANDO O PROCESSO DE RUÍDO BRANCO

L = 30;
N = 10000;

%L número de pontos - variáveis aleatórias
%N número de amostras

mu  =  zeros(1,L);
SIGMA  = eye(L);   
r  =  mvnrnd(mu,SIGMA,N);
figure(1)
hold on

%plot de  todas  as  janelas  de  ruído 
for  i=1:N;
    plot(r(i,:),'color',rand(1,3));
end
title('Funções-amostra entrada')
figure(2);
bar3(cov(r)); 
title('Covariância sinais entrada')
%covariancia

figure(3)
hist(r)
title('Processo Gaussiano')

%para ver se é branco
% CORRELAÇÃO

Rxx=  zeros(1,  2*L-1);

for CONT = 1:1:N
    signal = r(CONT,:);
    
for  k  =  -L+1:L-1
    ndx1  =  max([1  1+k]):min([L+k  L]);
    ndx2  =  max([1  1-k]):min([L-k  L]);
    Rxx(L+k)  = Rxx(L+k) + sum(signal(ndx1).*signal(ndx2))./L;
end
end
figure(4)
stem(Rxx);
title('Autocorrelação da entrada')

%Xi versus Xj

figure(5)
for num = 1:1:N-1

plot(r(num,:),r(num+1,:),'o')
hold on
end
xlabel('Xi') 
ylabel('Xj')

%ESPECTRO DE POTENCIA ENTRADA

M=2*L-1;
w  = -pi+pi/M:2*pi/M:pi; %valores em w
Sxx_noisy=  abs(fftshift(fft(Rxx)))/10000;
figure(6)
plot(w,Sxx_noisy(1:M));
title('Espectro de potencia da entrada')
hold on

%fazendo  a  média  do  espectro  de  potência  SYY
stp=  6;  %num.  de  pontos  para  fazer  a  média
SxxMean=  zeros(1,  (M+1)/stp);
for  i  =  1:stp:M
    if i  <  (M+1)/2
        SxxMean((i-1)/stp+1)  =  mean(Sxx_noisy(i:i+stp-1));
    else
        SxxMean((i-1)/stp+1)  =    mean(Sxx_noisy(i-1:i+stp-2));
    end
end

range  =  w(round(stp/2)+30):stp:length(w);
plot((range-27)*pi/30,  SxxMean,'r');












