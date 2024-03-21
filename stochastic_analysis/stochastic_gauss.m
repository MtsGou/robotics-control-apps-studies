clear all
clc

%% QUEST�O N�MERO 1

%LETRA A - GERANDO O PROCESSO DE RU�DO BRANCO

L = 30;
N = 10;

%L n�mero de pontos
%N n�mero de amostras

mu = 0;
sigma  =  1;
t = [1:1:L];

%plotando cada amostra, sendo o i o n�mero da amostra


for i = [1:1:N]  

aux = randn(L,1) + mu;

f = aux; %parte correspondente � vari�vel aleat�ria Xi

figure(1)
plot(t,f);
hold on
end

CORRELACAO = corr(aux);
COVARIANCIA = cov(aux);

%% LETRA B


SIGMA = cov(aux);
MU = [mu; mu];

[X,Y]  =  meshgrid(-5:0.1:5,-5:0.1:5);
aux = (1/sqrt(2*pi))^2;

const = aux/sqrt(det(SIGMA));

temp=  [X(:)-MU(1)  Y(:)-MU(2)];
pdf=  const*exp(-0.5*diag(temp*inv(SIGMA)*temp'));
pdf=  reshape(pdf,size(X));

figure(2)
surfc(X,  Y,  pdf,  'LineStyle',  'none');


%% LETRAS C e D

COVARIANCIA
CORRELACAO
 
r  =  mvnrnd(MU,SIGMA,10000);
figure(3)
hold on
for i=1:1000;
plot(r(i,:));
end

figure(4);
bar3(cov(r));  %plotda  covariancia

figure(5)
plot(f_x,f_y,'o')
xlabel('X') 
ylabel('Y')
 






