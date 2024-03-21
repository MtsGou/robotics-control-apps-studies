%PLOT do robo

goalcorpo = Trs(ROT(corpo, G(3)), G(1), G(2));
goalrodae = Trs(ROT(RE, G(3)), G(1), G(2));
goalrodad = Trs(ROT(RD, G(3)), G(1), G(2));

robocorpo = Trs(ROT(corpo, P(3)), P(1), P(2));
roborodae = Trs(ROT(RE, P(3)), P(1), P(2));
roborodad = Trs(ROT(RD, P(3)), P(1), P(2));

% plot do ponto objetivo
fill(goalcorpo(1,:), goalcorpo(2,:), 'w')
hold on
fill(goalrodae(1,:), goalrodae(2,:), 'k')
fill(goalrodad(1,:), goalrodad(2,:), 'k')

% plot da posicao atual do robo
fill(robocorpo(1,:), robocorpo(2,:), 'g')
fill(roborodae(1,:), roborodae(2,:), 'k')
fill(roborodad(1,:), roborodad(2,:), 'k')

% plot caminho obstaculos

obstaculo1 = [-300 -300 -600 -600;
              -400 3400 3400 -400]/1000;

obstaculo2 = [-300 866 2030 2030 -300;
              3000 1800 3000 3400 3400]/1000;
          
obstaculo3 = [2030 2030 2330 2330;
              -400 3400 3400 -400]/1000;
          
obstaculo4 = [300 866 1430 1430 300;
              1400 900 1400 -400 -400]/1000;
          
fill(obstaculo1(1,:), obstaculo1(2,:), 'k')
hold on
fill(obstaculo2(1,:), obstaculo2(2,:), 'k')
fill(obstaculo3(1,:), obstaculo3(2,:), 'k')
fill(obstaculo4(1,:), obstaculo4(2,:), 'k')

title('Aperte para dar início à Simulação'); 

plot(R(1,:), R(2,:), 'r', 'linewidth',4); % historico
hold off; axis equal; grid on;