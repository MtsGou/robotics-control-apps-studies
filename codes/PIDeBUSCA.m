clc
clear all

%% CONTROLE PID DE ROBO E BUSCA

AlgoritmodebuscaA;
pause;
hold on;

% CORPO DO ROBO:

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

Trajetotimo = Trajetotimo';

% POSICAO INICIAL

anguloinicial = atan((Trajetotimo(2,2)-Trajetotimo(2,1))...
    /(Trajetotimo(1,2)-Trajetotimo(1,1)));

if (Trajetotimo(2,2)-Trajetotimo(2,1)) > 0 && anguloinicial < 0

anguloinicial = anguloinicial + pi;
    
end

if (Trajetotimo(2,2)-Trajetotimo(2,1)) < 0 && anguloinicial > 0

anguloinicial = anguloinicial + pi;
    
end

if ((Trajetotimo(2,2)-Trajetotimo(2,1)) == 0) && ((Trajetotimo(1,2)-Trajetotimo(1,1)) < 0) 
 if  anguloinicial == 0
anguloinicial = anguloinicial + pi;
 end 
end

disp('O angulo de partida e')
disp(rad2deg(anguloinicial))

P = [Trajetotimo(:,1) 
     anguloinicial];

R = P; %historico

% Intervalo de amostragem [seg]

dt = 0.1;

%============ PLANEJAMENTO MALHA FECHADA ================================%

krho = 4;

% Parametros PID

Kp = 5;
Ki = 2; 
Kd = 2;

dif_erro = 0;
int_erro = 0;
alpha_anterior = 0;

% Criterio de parada

epsilon = 0.05;

% Limites de velocidade

vmax = 0.45; % [m/s]
wmax = deg2rad(180); % [360�/seg]

% ======================= LOOP PID ======================================%

for i = 1:size(Trajetotimo,2)

G = Trajetotimo(:,i);    
    
Dx = G(1) - P(1);
Dy = G(2) - P(2);

rho = sqrt(Dx^2 + Dy^2);
gamma = AjustaAngulo(atan2(Dy, Dx));
alpha = AjustaAngulo(gamma - P(3));

if i == 1
    PlotPIDBusca;
    set(gca, 'XTickLabel', [])
    xlabel('Aperte para dar in�cio � Simula��o');
    pause;
end
   
while (rho > epsilon)    
Dx = G(1) - P(1);
Dy = G(2) - P(2);

rho = sqrt(Dx^2 + Dy^2);
gamma = AjustaAngulo(atan2(Dy, Dx));
alpha = AjustaAngulo(gamma - P(3));

dif_erro = (alpha - alpha_anterior);
alpha_anterior = alpha;
int_erro = int_erro + alpha;

% limitar velocidades

w = Kp*alpha + Ki*int_erro + Kd*dif_erro;
w = sign(w)*min(abs(w), wmax);

if i < size(Trajetotimo,2)
    v = vmax;
else
    v = min(krho*rho, vmax);
end

if abs(alpha) > pi/2
    v = -v;
    alpha = AjustaAngulo(alpha + pi);
end

% Modelo diferencial

dP = [v*cos(P(3)) v*sin(P(3)) w]';
P = P + dP*dt;

P(3) = AjustaAngulo(P(3));
    
R = [R, P]; % armazena as posi��es anteriores 

    figure(2)
    axis([0.5 20.5 0.5 20.5]);
    % plot do ponto objetivo
    plot(Trajetotimo(1,:), Trajetotimo(2,:),'-og','LineWidth', 3);
    
    PlotPIDBusca;
    title(sprintf('\\nu = %.4f m/s, \\omega = %.2f �/s', v, rad2deg(w)));
    drawnow;

end

end

PlotPIDBusca;
title('Fim');