# -*- coding: utf-8 -*-
"""
"""
import numpy as np
import matplotlib.pyplot as plt

# intervalo 500 iteracoes 0 a 2pi
t = np.linspace(0, 2*np.pi, 500)

# funcao posicao do robô
px = 10*((np.sin(t))**3)
py = 5*((np.cos(t))**3)

# erro gaussiano para x e y
ex = np.random.randn(len(t))
ey = np.random.randn(len(t))

# GPS

sx = px + ex
sy = py + ey

fig, ax = plt.subplots()
linha_um, = ax.plot(sx, sy, color = 'r', linewidth = 1.5)
linha_dois, = ax.plot(px, py, color = 'k')

plt.xlabel('X')
plt.ylabel('Y')
plt.plot(sx,sy, 'r-', linewidth = 1.5)
plt.plot(px,py, 'k-', linewidth = 1)
plt.legend(['GPS','Robô'])
plt.grid(True)

plt.show()

