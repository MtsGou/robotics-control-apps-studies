clear all
clc

%GERANDO O PROCESSO DE RU�DO BRANCO

L = 30;
N = 10000;

%L n�mero de pontos - vari�veis aleat�rias
%N n�mero de amostras

mu  =  zeros(1,L);
SIGMA  = eye(L);   
r  =  mvnrnd(mu,SIGMA,N);
figure(1)
hold on

%plot de  todas  as  janelas  de  ru�do 
for  i=1:N;
    plot(r(i,:),'color',rand(1,3));
end
title('Fun��es-amostra entrada')
figure(2);
bar3(cov(r)); 
title('Covari�ncia sinais entrada')
%covariancia

figure(3)
hist(r)
title('Processo Gaussiano')

%para ver se � branco
% CORRELA��O

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
title('Autocorrela��o da entrada')

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

%fazendo  a  m�dia  do  espectro  de  pot�ncia  SYY
stp=  6;  %num.  de  pontos  para  fazer  a  m�dia
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












