clc
clear all

%% CONTROLE PID DE ROBO ENTRE DOIS PONTOS 

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


% POSICAO INICIAL

P = [0 0 deg2rad(0)]';
G = [2 2 deg2rad(60)]';

R = P; %historico

%PLOT do robo

goalcorpo = Trs(ROT(corpo, G(3)), G(1), G(2));
goalrodae = Trs(ROT(RE, G(3)), G(1), G(2));
goalrodad = Trs(ROT(RD, G(3)), G(1), G(2));

robocorpo = Trs(ROT(corpo, P(3)), P(1), P(2));
roborodae = Trs(ROT(RE, P(3)), P(1), P(2));
roborodad = Trs(ROT(RD, P(3)), P(1), P(2));

% plot do ponto objetivo
plot(G(1), G(2), 'o')
hold on

% plot da posicao atual do robo
fill(robocorpo(1,:), robocorpo(2,:), 'g')
fill(roborodae(1,:), roborodae(2,:), 'k')
fill(roborodad(1,:), roborodad(2,:), 'k')

title('Aperte para dar in�cio � Simula��o');
ylabel('Y')
xlabel('X')
plot(R(1,:), R(2,:), 'r', 'linewidth',4); % historico
hold off; axis equal; grid on;

pause;

% Intervalo de amostragem [seg]

dt = 0.1;

%============ PLANEJAMENTO MALHA FECHADA ================================%

krho = 4;

% Parametros PID

Kp = 5;
Ki = 2; 
Kd = 4;

dif_erro = 0;
int_erro = 0;
alpha_anterior = 0;

% Criterio de parada

epsilon = 0.01;

% Limites de velocidade

vmax = 0.35; % [m/s]
wmax = deg2rad(360); % [360�/seg]


% ======================= LOOP PID ======================================%

for i = 1:size(G,2)

Dx = G(1) - P(1);
Dy = G(2) - P(2);

rho = sqrt(Dx^2 + Dy^2);
gamma = AjustaAngulo(atan2(Dy, Dx));
alpha = AjustaAngulo(gamma - P(3));    
    
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

if i < size(G,2)
    v = vmax;
else
    v = min(krho*rho, vmax);
end

% Modelo diferencial

dP = [v*cos(P(3)) v*sin(P(3)) w]';
P = P + dP*dt;

P(3) = AjustaAngulo(P(3));
    
R = [R, P]; % armazena as posi��es anteriores 

%PLOT do robo

goalcorpo = Trs(ROT(corpo, G(3)), G(1), G(2));
goalrodae = Trs(ROT(RE, G(3)), G(1), G(2));
goalrodad = Trs(ROT(RD, G(3)), G(1), G(2));

robocorpo = Trs(ROT(corpo, P(3)), P(1), P(2));
roborodae = Trs(ROT(RE, P(3)), P(1), P(2));
roborodad = Trs(ROT(RD, P(3)), P(1), P(2));

plot(G(1), G(2), 'o')
hold on

% plot da posicao atual do robo
fill(robocorpo(1,:), robocorpo(2,:), 'g')
fill(roborodae(1,:), roborodae(2,:), 'k')
fill(roborodad(1,:), roborodad(2,:), 'k')

plot(R(1,:), R(2,:), 'r', 'linewidth',4); %historico
ylabel('Y')
xlabel('X')
hold off; axis equal; grid on;

title(sprintf('\\nu = %.4f m/s, \\omega = %.2f �/s', v, rad2deg(w)));
drawnow;

end
end

goalcorpo = Trs(ROT(corpo, G(3)), G(1), G(2));
goalrodae = Trs(ROT(RE, G(3)), G(1), G(2));
goalrodad = Trs(ROT(RD, G(3)), G(1), G(2));

robocorpo = Trs(ROT(corpo, P(3)), P(1), P(2));
roborodae = Trs(ROT(RE, P(3)), P(1), P(2));
roborodad = Trs(ROT(RD, P(3)), P(1), P(2));

plot(G(1), G(2), 'o')
hold on

% plot da posicao atual do robo
fill(robocorpo(1,:), robocorpo(2,:), 'g')
fill(roborodae(1,:), roborodae(2,:), 'k')
fill(roborodad(1,:), roborodad(2,:), 'k')

plot(R(1,:), R(2,:), 'r', 'linewidth',4); % historico
ylabel('Y')
xlabel('X')
hold off; axis equal; grid on;

title(sprintf('\\nu = %.4f m/s, \\omega = %.2f �/s', v, rad2deg(w)));
drawnow;

title('Fim');
