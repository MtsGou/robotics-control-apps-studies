# -*- coding: utf-8 -*-

import numpy as np
import matplotlib.pyplot as plt

pi = np.pi

# taxa de amostragem dt - 500 iteracoes

dt = 500

#intervalo

intervalo = np.linspace(0,2*pi,dt)

#criando a funcao da posicao real e o erro aleatorio

px = []
py = []
errox = []
erroy = []

for i in intervalo:
    seno = np.sin(i)
    cosseno = np.cos(i)
    a = 10*(seno**3)
    b = 5*(cosseno**3)
    c = np.random.randn(2)
    px.append(a)
    py.append(b)
    errox.append(c[0])
    erroy.append(c[1])
    
px = np.array(px)
py = np.array(py)
errox = np.array(errox)
erroy = np.array(erroy)

sx = px + errox
sy = py + erroy

plt.xlabel('X')
plt.ylabel('Y')
plt.plot(sx,sy, 'r-', linewidth = 1.5)
plt.plot(px,py, 'k-', linewidth = 1)
plt.legend(['GPS','Robô'])
plt.grid(True)

plt.show()





    
