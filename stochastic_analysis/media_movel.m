function h = media_movel(O)

n = 2*O; %N é a ordem do filtro média movel

%calcula-se a saída para qualquer tipo de entrada usando a convolução

impulse = [1 zeros(1,n)];
h = zeros(1,n);
h_aux = zeros(1,n);
h(1) = 1/(O+1);

for i = 2:n
    for j = 1:O
        if j < i
           
            h_aux(i) = impulse(i) + impulse(i-j);
            h(i) = h(i) + h_aux(i);
        else
            break;
        end
    end
end

for i = 2:n
    h(i) = h(i)/(O+1);
end

end

