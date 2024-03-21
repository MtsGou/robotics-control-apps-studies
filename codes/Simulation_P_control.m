clc
clear all

%-------------------------------------------------------------------------
% =========== [DEFINI��O DE VARI�VEIS E PLOTS] ===========================


% CORPO DO ROB�:

corpo = [100, 275.5, 275.5, 100, -200, -227.5, -227.5, -200;
         -190.5, -100, 100, 190.5, 190.5, 163, -163, -190.5]/1000;
    
corpo = [corpo; ones(1,8)];

% Roda direita:

RD = [97.5 97.5 -97.5 -97.5;
      -170.5 -210.5 -210.5 -170.5]/1000;

RD = [RD; ones(1,4)];
  
% Roda esquerda:

RE = [97.5 97.5 -97.5 -97.5;
      170.5 210.5 210.5 170.5]/1000;

RE = [RE; ones(1,4)];

% FUN��ES DE TRANSFORMA��O

%ROTA��O => ROT
%TRANSLA��O => Trs
% Ajuste de �ngulos => AjustaAngulo

%_________________________%
 %%%  PONTO OBJETIVO 1  %%%

G = [0 2.2 deg2rad(90)]'; 
    
% PONTO DE PARTIDA

P = [0 0 deg2rad(90)]';


% PARA PLOT

R = P; % armazenar posi��es
Plotsrobo;

pause; %clicar para continuar 

% Tempo de amostragem (seg)

dt = 0.1; 

%-------------------------------------------------------------------------
%============= [CONTROLE PROPORCIONAL] ==================================%

Dx = [];
Dy = [];
Dth = [];
rho = [];
gamma = [];
alpha = [];
beta = [];

[Dx, Dy, Dth, rho, gamma, alpha, beta] = calculo(G,P);

% Par�metros do controle proporcional

Kp = 4;
Ka = 10;
Kb = -5/4;

% Crit�rio de parada

epsilon = [0.001; deg2rad(0.5)]; %distancia de 0.01 m e 0.5�

LoopProporcional;

%_________________________%
 %%%  PONTO OBJETIVO 2  %%%
 
G = [0 2.2 deg2rad(135)]'; 
[Dx, Dy, Dth, rho, gamma, alpha, beta] = calculo(G,P);
Plotsrobo;
LoopProporcional;

%_________________________%
 %%%  PONTO OBJETIVO 3  %%%

G = [sqrt(3/4) 2.2-sqrt(3/4) deg2rad(135)]';
[Dx, Dy, Dth, rho, gamma, alpha, beta] = calculo(G,P);
Plotsrobo;
LoopProporcional;

%_________________________%
 %%%  PONTO OBJETIVO 4  %%%
 
G = [sqrt(3/4) 2.2-sqrt(3/4) deg2rad(45)]'; 
[Dx, Dy, Dth, rho, gamma, alpha, beta] = calculo(G,P);
Plotsrobo;
LoopProporcional;

%_________________________%
 %%%  PONTO OBJETIVO 5  %%%
G = [sqrt(3) 2.2 deg2rad(45)]'; 
[Dx, Dy, Dth, rho, gamma, alpha, beta] = calculo(G,P);
Plotsrobo;
LoopProporcional;

%_________________________%
 %%%  PONTO OBJETIVO 6  %%%
G = [sqrt(3) 2.2 deg2rad(90)]'; 
[Dx, Dy, Dth, rho, gamma, alpha, beta] = calculo(G,P);
Plotsrobo;
LoopProporcional;
 
%__________________________
 %%%  PONTO OBJETIVO 7  %%%
 
G = [sqrt(3) 0 deg2rad(90)]';
[Dx, Dy, Dth, rho, gamma, alpha, beta] = calculo(G,P);
Plotsrobo;
LoopProporcional;

Plotsrobo;
title('Fim');


