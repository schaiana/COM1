%Laboratório modulações digitais
%Schaiana Sonaglio
%Exercício 2

clear all; close all; clc;

%Parâmetros:

Rb = 500; 
bits = 4;
m = 2^bits;
simb_info = 10;
fc = 1e3;
up = 40;
tb = 1/Rb;
ta = tb/up;
t = [0:ta:(tb*simb_info)-ta];

%Gerando a informação
info = randint(1, simb_info, m); 
figure(1)
subplot(311)
stem(info)
grid on
ylim([-1 16])
title('Bits da informação')

%Superamostrando o sinal
filtro_NRZ = ones(1, up);
info_up = upsample(info, up); 
sinal_tx = filter(filtro_NRZ, 1, info_up); 
subplot(312)
plot(t, sinal_tx)
grid on
ylim([-1 16])
title('Sinal da informação')

%Portadora
A = 1;
phi = 0;
c_t = A*cos(2*pi*fc*t+phi);

%Modulação ASK
ask = sinal_tx.*c_t;

%Modulação PSK
phi = (2*pi* sinal_tx)/m;
psk = A*cos(2*pi*fc*t+phi);

%Modulação QAM
info_up = rectpulse(info, up);
qam = psk.*info_up;

%Plots
figure(1)
subplot(611)
stem(info)
grid on
title('Bits da informação')
subplot(612)
plot(t, sinal_tx)
grid on
title('Sinal da informação')
subplot(613)
plot(t, c_t);
grid on
title('Portadora')
subplot(614)
plot(t, ask);
grid on
title('Sinal modulado em ASK')
subplot(615)
plot(t, psk);
grid on
title('Sinal modulado em PSK')
subplot(616)
plot(t, qam);
grid on
title('Sinal modulado em QAM')