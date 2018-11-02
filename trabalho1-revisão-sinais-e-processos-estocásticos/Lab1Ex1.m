% 1)
% Gerar três sinais com frequências de 1kHz, 3kHz e 5kHz com amplitudes 6, 2 e 4, 
% respectivamente, e outro sinal s sendo este a soma dos outros três. 
% Plotar todos os sinais no domínio do tempo e da frequência.
% Determinar a potência média de s(t), assim como sua densidade espectral 
% de potência (utilizando a função pwelch).

clear all; close all; clc;

%Frequências dadas

f1 = 1000;
f2 = 3000;
f3 = 5000;

%Taxa de amostragem e intervalo de amostragem

fs = 10*f3;
Ts = 1/fs;

%Eixo do tempo e da frequência

te = 0.1; %tempo escolhido para análise
t = 0:Ts:(te-Ts);

n = te/Ts; %amostras
freq = -fs/2:(fs/n):((fs/2)-(fs/n));

%Sinais gerados e suas respectivas transformadas de Fourier
a = 6*sin(2*pi*f1*t);
b = 2*sin(2*pi*f2*t);
c = 4*sin(2*pi*f3*t);

s = a+b+c;

A = fftshift(fft(a));
B = fftshift(fft(b));
C = fftshift(fft(c));
S = fftshift(fft(s));

figure(1);

%Tempo
subplot(421)
plot(t, a); 
ylim([-8 8]); 
xlim([0 0.003]);
title('a: 6*sin(2*pi*1000t)');

subplot(423)
plot(t, b); 
ylim([-8 8]); 
xlim([0 0.003]);
title('b: 2*sin(2*pi*3000t)');

subplot(425)
plot(t, c); 
ylim([-8 8]);
xlim([0 0.003]);
title('c: 4*sin(2*pi*5000t)');

subplot(427)
plot(t, s);
ylim([-8 8]);
xlim([0 0.003]);
title('s: soma dos sinais');

%Frequência
subplot(422)
plot(freq,abs(A)/n)
title('A: domínio da frequência');
subplot(424)
plot(freq,abs(B)/n)
title('B: domínio da frequência');
subplot(426)
plot(freq,abs(C)/n)
title('C: domínio da frequência');
subplot(428)
plot(freq,abs(S)/n)
title('S: domínio da frequência');

%Potência média do sinal s(t)
Pot = ((norm(s)).^2)/n;
teste = (1/length(s))*sum(s.^2);

%Densidade espectral de potência
figure(2)
pwelch(s,[],[],[],fs,'onesided')
