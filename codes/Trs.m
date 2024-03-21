function newM = Trs(M, deltax, deltay)

% TRANSLAÇÃO

T = [1 0 deltax
     0 1 deltay
     0 0 1];
newM = T*M; 

end