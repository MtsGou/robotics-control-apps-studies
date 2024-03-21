    
hold on;

for CONTCOL = 0.5: COLUNAS + 0.5
    plot(CONTCOL*ones(1, LINHAS + 1),0.5: LINHAS + 0.5, 'k')
end

for CONTLIN = 0.5: LINHAS + 0.5
    plot(0.5: COLUNAS + 0.5, CONTLIN*ones(1, COLUNAS + 1),'k')
end

%obstaculos

plot(historicobst(1,:),historicobst(2,:),'sk','markersize', round(200/LINHAS)-7, 'LineWidth', 4);
plot(historicobst(1,:),historicobst(2,:),'*k','markersize', round(200/LINHAS)-7, 'LineWidth', 4);

%PLOT do robo

robocorpo = Trs(ROT(corpo, P(3)), P(1), P(2));
roborodae = Trs(ROT(RE, P(3)), P(1), P(2));
roborodad = Trs(ROT(RD, P(3)), P(1), P(2));

% plot da posicao atual do robo
fill(robocorpo(1,:), robocorpo(2,:), 'g')
hold on;
fill(roborodae(1,:), roborodae(2,:), 'k')
fill(roborodad(1,:), roborodad(2,:), 'k')

plot(R(1,:), R(2,:), 'r', 'linewidth',2); % historico

%Orientacao
plot([P(1) P(1)+0.1*cos(P(3))],[P(2) P(2)+0.1*sin(P(3))],...
    'k','LineWidth',2)
hold off;

axis equal;