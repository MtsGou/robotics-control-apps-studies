function [Dx, Dy, Dth, rho, gamma, alpha, beta] = calculo(G,P)

Dx = G(1) - P(1);
Dy = G(2) - P(2);
Dth = G(3) - P(3);

% rho => vetor G - P

rho = sqrt(Dx^2 + Dy^2);

% ângulo gama 

gamma = AjustaAngulo(atan2(Dy, Dx));

% ângulo alpha

alpha = AjustaAngulo(gamma - P(3));

% ângulo beta

beta = AjustaAngulo(G(3) - gamma);

end

