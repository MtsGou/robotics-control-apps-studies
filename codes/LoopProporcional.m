while (rho > epsilon(1)) || (abs(alpha) > epsilon(2)) || (abs(beta) > epsilon(2))
    
    % Recalcula tudo
    [Dx, Dy, Dth, rho, gamma, alpha, beta] = calculo(G,P);
   
    % LIMITAR ALPHA
    
    if (alpha > deg2rad(180))
        
        alpha = deg2rad(180);
        
    end
    
     if (alpha < deg2rad(-180))
        
        alpha = deg2rad(-180);
        
     end
    
    % LIMITAR BETA
    
     if (beta > deg2rad(180))
        
        beta = deg2rad(180);
        
    end
    
     if (beta < deg2rad(-180))
        
        beta = deg2rad(-180);
        
     end
    
    v = Kp*rho; 
    
    if (v > 0.35) % LIMITAR VELOCIDADE LINEAR
    
        v = 0.35;
        
    end
    
    if abs(alpha) > pi/2 %habilitar ré
    
        v = -v;
        alpha = AjustaAngulo(alpha + deg2rad(180));
        beta = AjustaAngulo(beta + deg2rad(180));
        
    end
    
    w = Ka*alpha + Kb*beta;
    
    
    if (w > deg2rad(360)) % LIMITAR VELOCIDADE ANGULAR
    
        w = deg2rad(360);
        
    end
    
    if (w < deg2rad(-360)) 
    
        w = deg2rad(-360);
        
    end
    
    % Modelo diferencial
    
    dTM =[cos(P(3)) 0; 
          sin(P(3)) 0;
          0         1];
      
    dP = dTM*[v w]';
    
    % Integrar em discretizações dt = 0.1 seg
    
    P = P + dP*dt;
    P(3) = AjustaAngulo(P(3));
    
    R = [R, P]; % armazena as posições anteriores 
    
    Plotsrobo;
    
    title(sprintf('\\nu = %.4f m/s, \\omega = %.2f º/s', v, rad2deg(w)));
    drawnow;
end