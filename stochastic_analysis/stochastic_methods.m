clear all
clc

L = 30;
N = 10000;

%L número de pontos - variáveis aleatórias
%N número de amostras

mu  =  zeros(1,L);
SIGMA  = eye(L);   
r  =  mvnrnd(mu,SIGMA,N);

%plot de  todas  as  janelas  de  ruído 
%for  i=1:N;
 %   plot(r(i,:),'color',rand(1,3));
%end

%COVARIANCIA DA SAIDA

h1 = media_movel(2);
h2 = media_movel(3);
h3 = media_movel(4);
h4 = media_movel(5);
a = 50;

for cont = 1:1:N
    
% FILTRO 1

filt1(cont,:) = conv(h1, r(cont,:));
aux = filt1(cont,:);
while a<length(aux)
    aux(a+1)=[];
end

filt = aux;
y1(cont,:)= filt;

end

for cont = 1:1:N
    
% FILTRO 2

filt2(cont,:) = conv(h2, r(cont,:));
aux = filt2(cont,:);
while a<length(aux)
    aux(a+1)=[];
end

filt = aux;
y2(cont,:)= filt;

end

for cont = 1:1:N
    
% FILTRO 3

filt3(cont,:) = conv(h3, r(cont,:));
aux = filt3(cont,:);
while a<length(aux)
    aux(a+1)=[];
end

filt = aux;
y3(cont,:)= filt;

end

for cont = 1:1:N
    
% FILTRO 4

filt4(cont,:) = conv(h4, r(cont,:));
aux = filt4(cont,:);
while a<length(aux)
    aux(a+1)=[];
end

filt = aux;
y4(cont,:)= filt;

end

%plot de  todas  as  janelas  de  ruído 
for  i=1:N;
    plot(y1(i,:),'color',rand(1,3));
    hold on
end
title('Amostras filtradas')

figure(2)
bar3(cov(y3))
title('Covariancia na Saída - Filtro ordem 4')



