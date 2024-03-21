clear all
clc

cont = 0;
for i = 0:pi/250:2*pi
    cont = cont + 1;
    p(1,cont) = 10*((sin(i)^3));
    p(2,cont) = 5*((cos(i)^3));
    e(1,cont) = randn(1);
    e(2,cont) = randn(1);
end

s = p + e;

t = 0: pi/250: 2*pi;

for j = 1:length(t)

    plot(s(1,1:j), s(2,1:j), 'color', 'r', 'LineWidth', 1.5);
    plot(p(1,1:j), p(2,1:j), 'color', 'k', 'LineWidth', 2);
    axis([-12 12 -10 10]);
    hold on
    grid on
    xlabel('X');
    ylabel('Y');
    legend('Robô','GPS');
    pause(0.001)
   
end
