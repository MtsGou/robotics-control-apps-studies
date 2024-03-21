% ALGORITMO A* PLANEJAMENTO DE CAMINHOS

clear all
clc

%% MAPA

LINHAS = 20;
COLUNAS = 20;

% MAPA INICIAL

Mapa = ones(LINHAS, COLUNAS);

box on;
hold on;

for i = 0.5: COLUNAS + 0.5
    plot(i*ones(1, LINHAS + 1),0.5: LINHAS + 0.5, 'k')
end

for j = 0.5: LINHAS + 0.5
    plot(0.5: COLUNAS + 0.5, j*ones(1, COLUNAS + 1),'k')
end

axis equal;

% ESCOLHA DOS OBSTACULOS PELO USUARIO

xlabel('Coloque os obstaculos');

uiwait(msgbox('Coloque os obstaculos pressionando o botao esquerdo depois o direito'), 10);

click = 1;

historicobst = zeros(2, LINHAS*COLUNAS);
contaux = 0;

while click == 1
    
    contaux = contaux + 1;
    [xObs, yObs, click] = ginput(1);
    xObs = round(xObs);
    yObs = round(yObs);
    Mapa(yObs, xObs) = -1;
    plot(xObs,yObs,'sk','markersize', round(200/LINHAS)-7, 'LineWidth', 4);
    plot(xObs,yObs,'*k','markersize', round(200/LINHAS)-7, 'LineWidth', 4);
    
    historicobst(1,contaux) = xObs;
    historicobst(2,contaux) = yObs;
    
end

for u = 1:size(historicobst,2)
   
    if historicobst(:,u) == 0
       
        historicobst = historicobst(:,1:u-1);
        break
    end
    
end

% ESCOLHA DOS PONTOS OBJETIVO E INICIAL PELO USUARIO

xlabel('Escolha o ponto inicial');
uiwait(msgbox('Coloque o ponto inicial pressionando o botao esquerdo'), 10);

[x0, y0] = ginput(1);
x0 = round(x0);
y0 = round(y0);

plot(x0, y0, 'ob');
plot(x0, y0, '*b');
text(x0 - 0.25, y0 + 0.3, 'Inicio', 'Color', 'blue');

Mapa(y0, x0) = 2;


xlabel('Escolha o ponto objetivo');
uiwait(msgbox('Coloque o ponto objetivo pressionando o botao esquerdo'), 10);

[xG, yG] = ginput(1);
xG = round(xG);
yG = round(yG);

plot(xG, yG, 'or');
plot(xG, yG, '*r');
text(xG - 0.4, yG + 0.3, 'Goal', 'Color', 'red');

Mapa(yG, xG) = 0;

clear xObs yObs click i j

%% IMPLEMENTACAO DO ALGORITMO

tic

xC = x0; %current
yC = y0;

xN = xC; %neighbor
yN = yC;

% F = g + h

% g:

Custo0C = sqrt((xC - x0)^2 + (yC - y0)^2);

CustoCN = sqrt((xN - xC)^2 + (yN - yC)^2);

g = Custo0C + CustoCN;

% h:

h = sqrt((xG - xN)^2 + (yG - yN)^2);

F = g + h;

CelAbt = [0, xC, yC, xN, yN, Custo0C, F];

[yObs, xObs] = find(Mapa == -1);
CelFec = [xObs, yObs];

CelFec = [CelFec; [xC, yC]];


xlabel('Aperte espaco para rodar o algoritmo');
pause;
set(gca, 'XTickLabel', [])
xlabel('Analise do caminho');


while (xC ~= xG) || (yC ~= yG)
    
    for dx = -1:1
        for dy = -1:1
            
            xN = xC + dx;
            yN = yC + dy;
            
            if (0 < xN && xN <= COLUNAS) && (0 < yN && yN <= LINHAS) ...
                    && (max(xN == CelFec(:,1) & yN == CelFec(:,2)) == 0)
            
                CustoCN = sqrt((xN - xC)^2 + (yN - yC)^2);
                
                g = Custo0C + CustoCN;
                
                h = sqrt((xG - xN)^2 + (yG - yN)^2);
                
                F = g + h;
                
                
                if sum(CelAbt(:,4) == xN & CelAbt(:, 5) == yN) == 1

                    indAb = find(CelAbt(:,4) == xN & CelAbt(:,5) == yN);
                    if CelAbt(indAb, 7) > F
                        
                        CelAbt(indAb, 2) = xC;
                        CelAbt(indAb, 3) = yC;
                        CelAbt(indAb, 6) = g;  
                        CelAbt(indAb, 7) = F;
                        drawnow;
                    end
                    
                else
                    CelAbt = [CelAbt; [true, xC, yC, xN, yN, g, F]];
                end
            end
        end
    end
    
    CelLiv = find(CelAbt(:,1) == 1);
    
    if size(CelLiv, 1) > 0
        
        IndMinF = CelLiv(find(min(CelAbt(CelLiv, 7)) == CelAbt(CelLiv, 7),1, 'first'));
        
        xC = CelAbt(IndMinF, 4);
        yC = CelAbt(IndMinF, 5);
        
        Custo0C = CelAbt(IndMinF, 6);
        CelFec = [CelFec; [xC yC]];
        CelAbt(IndMinF, 1) = 0;
        
    else
        
        disp('Nao ha caminho possivel ate o objetivo');
        break
    end
        pause(0.000001)
    
    hold on;
    plot(xC, yC, '.m','LineWidth', 2, 'markersize', 15)
    drawnow
end

% PERCORRRER CAMINHO INVERSO

xInv = CelFec(end, 1);
yInv = CelFec(end, 2);

if (xInv == xG) && (yInv == yG)
    
    Trajetotimo = [xInv yInv];
    
    indInv = find(xInv == CelAbt(:,4) & yInv == CelAbt(:,5) & 0 == ...
        CelAbt(:,1),1,'last');
    CustoTotal = CelAbt(indInv, 7);
    
    while (xInv ~= x0) || (yInv ~= y0)
        
        indInv = find(xInv == CelAbt(:, 4) & yInv == CelAbt(:,5) ...
            & 0 == CelAbt(:, 1),1,'last');
        
        xInv = CelAbt(indInv, 2);
        yInv = CelAbt(indInv, 3);
        
        Trajetotimo = [Trajetotimo; [xInv yInv]];
    end

    Trajetotimo = Trajetotimo(end: -1: 1, :);

hold on;
plot(Trajetotimo(:,1), Trajetotimo(:,2), '-o', 'LineWidth', 2)
end


    