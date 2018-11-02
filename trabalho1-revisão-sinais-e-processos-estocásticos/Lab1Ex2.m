% 2)
% Gerar três sinais com frequências de 1kHz, 3kHz e 5kHz com amplitudes 
% 5, 5/3 e 1, respectivamente, e outro sinal s sendo este a soma dos outros 
% três. Plotar todos os sinais no domínio do tempo e da frequência. 
% Gerar três filtros ideais: um filtro passa baixa (frequência de corte 
% em 2kHz), um passa alta (frequência de corte em 4kHz) e um filtro passa 
% faixa (banda de passagem entre 2 e 4 kHz). Plotar resposta em frequência
% dos filtros e passar o sinal s pelos filtros. Plotar as saídas no domínio
% do tempo e da frequência.

clear all; close all; clc;

%Frequências dadas

f1 = 1000;
f2 = 3000;
f3 = 5000;

%Taxa de amostragem e intervalo de amostragem

fs = 10*f3;
Ts = 1/fs;

%Eixo do tempo e da frequência

te = 0.01; %tempo escolhido para análise
t = 0:Ts:(te-Ts);

n = te/Ts; %amostras
freq = -fs/2:(fs/n):((fs/2)-(fs/n));

%Sinais gerados e suas respectivas transformadas de Fourier
a = 5*sin(2*pi*f1*t);
b = (5/3)*sin(2*pi*f2*t);
c = sin(2*pi*f3*t);

s = a+b+c;

A = fftshift(fft(a));
B = fftshift(fft(b));
C = fftshift(fft(c));
S = fftshift(fft(s));

figure(1);

%Tempo
subplot(421)
plot(t, a); 
ylim([-7 7]); 
xlim([0 0.003]);
title('a: 5*sin(2*pi*1000t)');

subplot(423)
plot(t, b); 
ylim([-10 10]); 
xlim([0 0.003]);
title('b: (5/3)*sin(2*pi*3000t)');

subplot(425)
plot(t, c); 
ylim([-10 10]);
xlim([0 0.003]);
title('c: sin(2*pi*5000t)');

subplot(427)
plot(t, s);
ylim([-10 10]);
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

%Filtros

%Passa Baixa (2kHz)
FPB = [zeros(1,230) ones(1,40) zeros(1, 230)];
%Passa Alta (4kHz)
FPA = [ones(1, 210) zeros(1, 80) ones(1, 210)];
%Passa Faixa (2kHz - 4kHz)
FPF = [zeros(1, 210) ones(1, 20) zeros(1, 40) ones(1, 20) zeros(1, 210)];

figure(2);
subplot(331)
plot(freq, FPB);
ylim([0 1.1]);
xlim([-20000 20000]);
title('Filtro Passa Baixa (2kHz)');

subplot(334)
plot(freq, FPF);
ylim([0 1.1]);
xlim([-20000 20000]);
title('Filtro Passa Faixa (2kHz - 4kHz)');

subplot(337)
plot(freq, FPA);
ylim([0 1.1]);
xlim([-20000 20000]);
title('Filtro Passa Alta (4kHz)');

%Passando o sinal somado, S, pelos filtros (Domínio da Frequência)

%S pelo Passa Baixa (2kHz)
SxFPB = S.*FPB;
sxfpb = ifft(ifftshift(SxFPB));

%S pelo Passa Faixa (2kHz - 4kHz)
SxFPF = S.*FPF;
sxfpf = ifft((ifftshift(SxFPF)));

%S pelo Passa Alta (4kHz)
SxFPA = S.*FPA;
sxfpa = ifft((ifftshift(SxFPA)));


subplot(332)
plot(freq,abs(SxFPB))
title('Sinal A após filtro passa baixa');
subplot(333)
plot(t, real(sxfpb))
title('Sinal a recuperado');

subplot(335)
plot(freq,abs(SxFPF))
title('Sinal B após filtro passa faixa');
subplot(336)
plot(t, real(sxfpf))
title('Sinal b recuperado');

subplot(338)
plot(freq,abs(SxFPA))
title('Sinal C após filtro passa alta');
subplot(339)
plot(t, real(sxfpa))
title('Sinal c recuperado');
