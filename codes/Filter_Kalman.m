clear all
clc

% =========== SISTEMA REAL =========== %

rng(18);

x = [0 % x inicial
     0 % y inicial
     2 % vx inicial
     2]; % vy inicial
 
 Hx = x; % historico
 
 % Coeficiente de atrito
 
 cfat = 0.96;
 
 % Tempo de Amostragem
 
 dt = 0.1; %seg
 
 % Matriz de transicao de estados
 
 A = [1 0 dt   0
      0 1 0    dt
      0 0 cfat 0
      0 0 0  cfat];
  
% Matriz de controle

B = zeros(size(x));  
u = 0;

% Desvios padroes sistema rastreado (dado)

sigma_x = 0.01;
sigma_y = 0.01;
sigma_vx = 0.02;
sigma_vy = 0.02;

% Matriz de covariancias Q

Q = [sigma_x^2 0         0          0
     0         sigma_y^2 0          0
     0         0         sigma_vx^2 0
     0         0         0          sigma_vy^2];
 
% ========== SENSOR REAL ========== % 

% Matriz do sensor

C = [1 0
     0 1];
 
C = [C zeros(2)];

% Desvios do sensor

sigma_sx = 0.2;
sigma_sy = 0.2;

% Matriz de covariancias sensor

R = [sigma_sx^2          0
     0          sigma_sy^2];
 
% Primeira leitura

z = C*x + sqrt(R)*randn(size(x(1:2)));

Hz = z; % historico

% =========== LOOP =========== %

t = 0;
tempo_max = 10; % s

% =========== FILTRO SENSOR ========== %

xk = [x(1); x(2); 2; 2];

% LONGE DO LUGAR
%xk = [6; 2; 2; 2];

Hxk = xk;

P = Q;

% Esperanca inicial do sensor

zk = C*xk;

Hzk = zk;
erro = abs(xk(1:2)-zk);

while t <= tempo_max
    
    zeta = randn(size(x(1:2)));
    zeta = [zeta; zeta];
    t = [t, t(end) + dt];
    
    % SISTEMA REAL
    x = A*x + B*u + sqrt(Q)*zeta;
    Hx = [Hx, x]; % historico armazenado
    
    % SENSOR 
    z = C*x + sqrt(R)*randn(size(x(1:2)));
    Hz = [Hz, z]; % historico armazenado
    
    % =========== FILTRO DE KALMAN ========== %
    
    % PREVISAO
    
    xk = A*xk + B*u;
    
    % covariancia
    
    P = A*P*A' + Q;
    
    % esperanca do sensor
    
    zk = C*xk;
    Hzk = [Hzk, zk];
    erro = [erro, abs(x(1:2, end)- zk)];
    
    % CORRECAO
    
    % ganho de Kalman
    
    K = P*C'*inv(C*P*C' + R);
    
    % correcao da esperanca
    
    xk = xk + K*(z - zk);
    Hxk = [Hxk, xk];
    
    % correcao da covariancia 
    
    P = (eye(size(Q))-K*C)*P;
    
    % PLOT
    p1 = plot(Hz(1,:), Hz(2,:), 'g', 'LineWidth', 3);
    hold on;
    p2 = plot(Hx(1,:), Hx(2,:), 'k', 'LineWidth', 2);
    plot(x(1), x(2), 'ok', 'LineWidth',2, 'markersize', 10);
    
    p3 = plot(Hzk(1,:), Hzk(2,:), 'r', 'LineWidth', 2);
    plot(zk(1), zk(2),'or','LineWidth',2, 'markersize', 10);
    
    
    axis([min([Hx(1,1) Hz(1,1) Hzk(1,1)]) max([Hx(1,:) Hz(1,:) Hzk(1,:)]) ...
          min([Hx(2,1) Hz(2,1) Hzk(2,1)]) max([Hx(2,:) Hz(2,:) Hzk(2,:)])]);
    xlabel('X [m]');
    ylabel('Y [m]');
    
    hold off; grid on;
    title(sprintf('t = %.1f s', t(end)-0.1));
    drawnow;
end
legend([p1 p2 p3],{'Sensor', 'Real','Kalman'},'Location','northwest');

figure(2)

subplot(2,1,1);
p1 = plot(t, Hz(1,:), 'g', 'LineWidth', 3);
title('Acompanhamento eixo x');
hold on
p2 = plot(t, Hx(1,:), 'k', 'LineWidth',2);
plot(t(end), x(1), 'ok', 'LineWidth',3, 'markersize', 10);

p3 = plot(t, Hzk(1,:), 'r', 'LineWidth',2);
plot(t(end), zk(1), 'or', 'LineWidth',2, 'markersize', 10);

legend([p1 p2 p3],{'Sensor', 'Real','Kalman'},'Location','southeast');

xlabel('t[s]');
ylabel('x[m]');
grid on;
hold off

subplot(2,1,2);
p1 = plot(t, Hz(2,:), 'g', 'LineWidth', 3);
title('Acompanhamento eixo y');
hold on
p2 = plot(t, Hx(2,:), 'k', 'LineWidth',2);
plot(t(end), x(2), 'ok', 'LineWidth',2, 'markersize', 10);

p3 = plot(t, Hzk(2,:), 'r', 'LineWidth',2);
plot(t(end), zk(2), 'or', 'LineWidth',2, 'markersize', 10);

legend([p1 p2 p3],{'Sensor', 'Real','Kalman'},'Location','southeast');

xlabel('t[s]');
ylabel('y[m]');
grid on;
hold off