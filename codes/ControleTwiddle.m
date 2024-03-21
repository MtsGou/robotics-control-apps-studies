function DeltaE = ControleTwiddle(K, plot_sim)

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

% Ponto Objetivo

G = [2 -2 deg2rad(315)]';

R = P; %historico

if plot_sim ==1

%PLOT do robo

goalcorpo = Trs(ROT(corpo, G(3)), G(1), G(2));
goalrodae = Trs(ROT(RE, G(3)), G(1), G(2));
goalrodad = Trs(ROT(RD, G(3)), G(1), G(2));

robocorpo = Trs(ROT(corpo, P(3)), P(1), P(2));
roborodae = Trs(ROT(RE, P(3)), P(1), P(2));
roborodad = Trs(ROT(RD, P(3)), P(1), P(2));

% plot do ponto objetivo
figure(1)
plot(G(1),G(2), 'o', 'linewidth', 3)
hold on

plot([0 G(1)],[0 G(2)],'g', 'linewidth', 4)

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

end

% Intervalo de amostragem [seg]

dt = 0.1;

%============ PLANEJAMENTO MALHA FECHADA ================================%

% Parametros PID

Kp = K(1);
Ki = K(2);
Kd = K(3);

dif_erro = 0;
int_erro = 0;
alpha_anterior = 0;

% Criterio de parada

epsilon = 0.1;

% Limites de velocidade

vmax = 0.35; % [m/s]
wmax = deg2rad(360); % [360�/seg]

%============ PROCESSO CALCULO DOS ERROS ================================%

P0 = P; % ponto inicial

G_raio = sqrt(G(1)^2 + G(2)^2);
G_theta = G(3);

G = [P0(1) + G_raio*cos(G_theta); P0(2) + G_raio*sin(G_theta); G(3)];

% Parametros da reta

a = G(2) - P0(2);

b = P0(1) - G(1);

c = G(1)*P0(2) - P0(1)*G(1);

erro = abs(a*P(1) + b*P(2) + c)/sqrt(a^2 + b^2);

% tempo inicial

t = 0;

% tempo maximo de simulacao a ser escolhido

tmax = 10*sqrt((G(1) - P0(1))^2 + (G(2) - P0(2))^2)/vmax;


% ======================= LOOP PID ======================================%

for i = 1:size(G,3)

Dx = G(1) - P(1);
Dy = G(2) - P(2);

rho = sqrt(Dx^2 + Dy^2);
gamma = AjustaAngulo(atan2(Dy, Dx));
alpha = AjustaAngulo(gamma - P(3));    
    
while (rho > epsilon) && (t <= tmax)
    
t = t + dt;    

Dx = G(1) - P(1);
Dy = G(2) - P(2);

rho = sqrt(Dx^2 + Dy^2);
gamma = AjustaAngulo(atan2(Dy, Dx));
alpha = AjustaAngulo(gamma - P(3));

dif_erro = (alpha - alpha_anterior);
alpha_anterior = alpha;
int_erro = int_erro + alpha;

if i < size(G,3)
    v = vmax;
else
    v = min(rho, vmax);
end

% habilitar re

if abs(alpha) > pi/2
    v = -v;
    alpha = AjustaAngulo(alpha + pi);
end

% limitar velocidades 

w = Kp*alpha + Ki*int_erro + Kd*dif_erro;
w = sign(w)*min(abs(w), wmax);

% Modelo diferencial

dP = [v*cos(P(3)) v*sin(P(3)) w]';
P = P + dP*dt;

P(3) = AjustaAngulo(P(3));
    
R = [R, P]; % armazena as posi��es anteriores 

erro = [erro; %abs(w)+... % para os quadrantes 2 e 3
        abs(a*P(1) + b*P(2) + c)/sqrt(a^2 + b^2)];

if plot_sim ==1

%PLOT do robo

goalcorpo = Trs(ROT(corpo, G(3)), G(1), G(2));
goalrodae = Trs(ROT(RE, G(3)), G(1), G(2));
goalrodad = Trs(ROT(RD, G(3)), G(1), G(2));

robocorpo = Trs(ROT(corpo, P(3)), P(1), P(2));
roborodae = Trs(ROT(RE, P(3)), P(1), P(2));
roborodad = Trs(ROT(RD, P(3)), P(1), P(2));

figure(1)
plot(G(1), G(2), 'o', 'linewidth', 3)
hold on
plot([0 G(1)],[0 G(2)],'g', 'linewidth', 4)

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

end

if plot_sim == 1

goalcorpo = Trs(ROT(corpo, G(3)), G(1), G(2));
goalrodae = Trs(ROT(RE, G(3)), G(1), G(2));
goalrodad = Trs(ROT(RD, G(3)), G(1), G(2));

robocorpo = Trs(ROT(corpo, P(3)), P(1), P(2));
roborodae = Trs(ROT(RE, P(3)), P(1), P(2));
roborodad = Trs(ROT(RD, P(3)), P(1), P(2));

plot(G(1), G(2), 'o', 'linewidth', 3)
hold on
plot([0 G(1)],[0 G(2)],'g', 'linewidth', 4)

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

for num = 1:length(erro)

    VetorTempo(num) = num;

end

figure(2)
plot((VetorTempo-1)/t, erro*1000, 'linewidth', 2);
xlabel('Tempo')
ylabel('Erro [mm]')
grid on
axis([0 3 0 1000*max(erro)])

end

DeltaE = mean(erro);


end
