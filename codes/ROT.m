function newM = ROT(M, th)

% ROTAÇÃO

Rz = [cos(th) -sin(th) 0; 
      sin(th) cos(th)  0; 
      0       0        1];
newM = Rz*M;  

end

