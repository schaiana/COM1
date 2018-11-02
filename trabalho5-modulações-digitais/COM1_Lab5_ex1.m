%Laboratório modulações digitais
%Schaiana Sonaglio
%Exercício 1

clear all; close all; clc;

%Parâmetros:
bits_info = 10;
up = 100;
tb = 1/500;
ta = tb/up;
n = 2;
fc = 1e3;
t = [0:ta:(tb*bits_info)-ta];

%Gerando a informação
info = randint(1, bits_info, n); 

%Superamostrando o sinal
filtro_NRZ = ones(1, up);
info_up = upsample(info, up); 
sinal_tx = filter(filtro_NRZ, 1, info_up); 

%Portadora
A = 1;
phi = 0;
c_t = A*cos(2*pi*fc*t+phi);

%Modulação ASK
ask = sinal_tx.*c_t;

%Modulação PSK
phi = (2*pi* sinal_tx)/n;
psk = A*cos(2*pi*fc*t+phi);

%Modulação FSK
fsk = A*cos(2*pi*fc*t.*(sinal_tx+1));
%Plots
figure(1)
subplot(611)
stem(info)
grid on
ylim([-0.1 1.1])
title('Bits da informação')
subplot(612)
plot(t, sinal_tx)
grid on
ylim([-0.1 1.1])
title('Sinal da informação')
subplot(613)
plot(t, c_t);
ylim([-1.1 1.1])
grid on
title('Portadora')
subplot(614)
plot(t, ask);
ylim([-1.1 1.1])
grid on
title('Sinal modulado em ASK')
subplot(615)
plot(t, psk);
ylim([-1.1 1.1])
grid on
title('Sinal modulado em PSK')
subplot(616)
plot(t, fsk);
ylim([-1.1 1.1])
grid on
title('Sinal modulado em FSK')
