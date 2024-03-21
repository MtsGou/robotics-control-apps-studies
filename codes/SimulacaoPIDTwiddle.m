clc
clear all

%% CONTROLE PID DE ROBO ENTRE DOIS PONTOS 

% ALGORITMO TWIDDLE 

% obter parametros Kp, Ki e Kd do controlador PID

K = [0 0 0]; % ponto de chute inicial

% atualizacao dos parametros

dK = [1 1 1];

% porcentagem de alteracao

ksi = 1/100;

% criterio de parada

delta = 0.01;

% menor erro

erro_menor = ControleTwiddle(K, 0);

j = 0;

while sum(dK) > delta
    
j = j + 1;

for u = 1: length(K)
    
    K(u) = K(u) + dK(u);
    erro = ControleTwiddle(K, 0);
    
    if erro < erro_menor
        
        erro_menor = erro;
        dK(u) = dK(u)*(1+ksi);
    
    else
        K(u) = K(u) - 2*dK(u);
        erro = ControleTwiddle(K, 0);
        
        if erro < erro_menor
            
            erro_menor = erro;
            dK(u) = dK(u)*(1+ksi);
        else
            K(u) = K(u) + dK(u);
            dK(u) = dK(u)*(1-ksi);
        end
    end
end

fprintf('Iteracao %i: Menor erro = %.4f, soma(dK) = %.4f\n', j,...
    erro_menor, sum(dK))

end

fprintf('Parametros PID: P = %.4f, I = %.4f, D = %.4f\n', K(1), K(2), K(3))
erro_menor = ControleTwiddle(K, 1);


