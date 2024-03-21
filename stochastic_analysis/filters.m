clear all
clc

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
%for  i=1:N;
 %   plot(r(i,:),'color',rand(1,3));
%end

x = r(1,:); % uma função amostra exemplo

%plot de uma função-amostra exemplo para cada filtro

% FILTRO 1 (ordem 2)

h1 = media_movel(2);
y1 = conv(h1, x);
a = 30;
while a<length(y1)
    y1(a+1)=[];
end
time1 = linspace(1,L,length(y1));

% FILTRO 2 (ordem 3)

h2 = media_movel(3);
y2 = conv(h2, x);
while a<length(y2)
    y2(a+1)=[];
end
time2 = linspace(1,L,length(y2));

% FILTRO 3 (ordem 4)

h3 = media_movel(4);
y3 = conv(h3, x);
while a<length(y3)
    y3(a+1)=[];
end
time3 = linspace(1,L,length(y3));

% FILTRO 4 (ordem 5)

h4 = media_movel(5);
y4 = conv(h4, x);
while a<length(y4)
    y4(a+1)=[];
end
time4 = linspace(1,L,length(y4));

subplot(4,1,1);
plot(time1,y1);
title('ordem 2')

subplot(4,1,2);
plot(time2,y2);
title('ordem 3')

subplot(4,1,3);
plot(time3,y3);
title('ordem 4')

subplot(4,1,4);
plot(time4,y4);
title('ordem 5')

figure(2)

subplot(2,1,1)
plot(time1,y1);
title('ordem 2')

subplot(2,1,2);
plot(time4,y4);
title('ordem 5')

%MATRIZES DE CORRELAÇÃO DA SAÍDA

%FILTRO 1 (ordem 2)%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

h1 = media_movel(2);
a = 30;

for CONT = 1:1:N 
x = r(CONT,:);
filt1(CONT,:) = conv(h1, x);
AUX = filt1(CONT,:);
while a<length(AUX)
    AUX(a+1)=[];
end

filt = AUX;
y1(CONT,:) = filt;

end

Ryy1=  zeros(1,  2*L-1);

for CONT = 1:1:N

    filteredsignal = y1(CONT,:);
    
for  k  =  -L+1:L-1
    ndx1  =  max([1  1+k]):min([L+k L]);
    ndx2  =  max([1  1-k]):min([L-k L]);
    Ryy1(L+k)  = Ryy1(L+k) + sum(filteredsignal(ndx1).*filteredsignal(ndx2))./L;
end
hold  on;
end

figure(3)
stem(Ryy1,'r');
title('Correlação Filtro ordem 2')

%FILTRO 2 (ordem 3)%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

h2 = media_movel(3);

for CONT = 1:1:N 
x = r(CONT,:);
filt2(CONT,:) = conv(h2, x);
AUX = filt2(CONT,:);
while a<length(AUX)
    AUX(a+1)=[];
end

filt = AUX;
y2(CONT,:) = filt;

end

Ryy2=  zeros(1,  2*L-1);

for CONT = 1:1:N

    filteredsignal = y2(CONT,:);
    
for  k  =  -L+1:L-1
    ndx1  =  max([1  1+k]):min([L+k L]);
    ndx2  =  max([1  1-k]):min([L-k L]);
    Ryy2(L+k)  = Ryy2(L+k) + sum(filteredsignal(ndx1).*filteredsignal(ndx2))./L;
end
hold  on;
end

figure(4)
stem(Ryy2,'r');
title('Correlação Filtro ordem 3')

%FILTRO 3 (ordem 4)%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

h3 = media_movel(4);

for CONT = 1:1:N 
x = r(CONT,:);
filt3(CONT,:) = conv(h3, x);
AUX = filt3(CONT,:);
while a<length(AUX)
    AUX(a+1)=[];
end

filt = AUX;
y3(CONT,:) = filt;

end

Ryy3=  zeros(1,  2*L-1);

for CONT = 1:1:N

    filteredsignal = y3(CONT,:);
    
for  k  =  -L+1:L-1
    ndx1  =  max([1  1+k]):min([L+k L]);
    ndx2  =  max([1  1-k]):min([L-k L]);
    Ryy3(L+k)  = Ryy3(L+k) + sum(filteredsignal(ndx1).*filteredsignal(ndx2))./L;
end
hold  on;
end

figure(5)
stem(Ryy3,'r');
title('Correlação Filtro ordem 4')

%FILTRO 4 (ordem 5)%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

h4 = media_movel(5);

for CONT = 1:1:N 
x = r(CONT,:);
filt4(CONT,:) = conv(h4, x);
AUX = filt4(CONT,:);
while a<length(AUX)
    AUX(a+1)=[];
end

filt = AUX;
y4(CONT,:) = filt;

end

Ryy4=  zeros(1,  2*L-1);

for CONT = 1:1:N

    filteredsignal = y4(CONT,:);
    
for  k  =  -L+1:L-1
    ndx1  =  max([1  1+k]):min([L+k L]);
    ndx2  =  max([1  1-k]):min([L-k L]);
    Ryy4(L+k)  = Ryy4(L+k) + sum(filteredsignal(ndx1).*filteredsignal(ndx2))./L;
end
hold  on;
end

figure(6)
stem(Ryy4,'r');
title('Correlação Filtro ordem 5')


%ESPECTRO DE POTENCIA SAIDA

%ESCOLHER FILTRO -----> filtro escolhido 1 (ordem 2)

M=2*L-1;
w  = -pi+pi/M:2*pi/M:pi; %valores em w
Syy_noisy=  abs(fftshift(fft(Ryy4)))/10000;
figure(7)
plot(w,Syy_noisy(1:M));
hold on
title('Espectro de potencia da saída filtro ordem 5')


%fazendo  a  média  do  espectro  de  potência  SYY
stp=  6;  %num.  de  pontos  para  fazer  a  média
SyyMean=  zeros(1,  (M+1)/stp);
for  i  =  1:stp:M
    if i  <  (M+1)/2
        SyyMean((i-1)/stp+1)  =  mean(Syy_noisy(i:i+stp-1));
    else
        SyyMean((i-1)/stp+1)  =    mean(Syy_noisy(i-1:i+stp-2));
    end
end

range  =  w(round(stp/2)+30):stp:length(w);
plot((range-27)*pi/30,  SyyMean,'r');


