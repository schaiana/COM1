% 3)
% Gerar um ruído com distribuição normal com duração de 1 segundo e tempo de 
% amostragem de 1/10kHz. Plotar o seu histograma, assim como sua 
% representação no domínio do tempo e da frequência. Determinar a 
% autocorrelação do ruído, filtrá-lo através da função 
% filtro = fir1(50, (1000*2)/fs) e visualizar a resposta em frequência do 
% filtro. Por fim, plotar o histograma e a representação tanto no domínio 
% do tempo quanto no da frequência do sinal filtrado.

close all;
clear all;
clc;

%Taxa de amostragem e intervalo de amostragem

fs = 10000; 
Ts = 1/fs;

%Eixo do tempo e da frequência

te = 1; 
n = te/Ts;
t = 0:Ts:(te - Ts);

freq = -fs/2:(fs/n):((fs/2)-(fs/n));

%Ruído (de média nula e variância unitária porque usa a distruibuição normal padrão) e sua transformada de Fourier
r = randn(1,10000);
R = fftshift(fft(r)); 

%Função de Autorrelação do ruído
[y, atrasos] = xcorr(r);

%Filtrando o ruído
filtro = fir1(50,(1000*2)/fs); 

%Ruído: Histograma
figure(1)
hist(r,100);
xlim([-6 6]);
title('Ruído: Histograma');

%Ruído: domínio do tempo e da frequência
figure(2)
subplot(311)
plot(t, r);
ylim([-3 3]);
title('Ruído: Domínio do Tempo');

subplot(312)
plot(freq, abs(R)/n);
title('Ruído: Domínio da Frequência');

%Ruído: Função de Autocorrelação
subplot(313)
plot(atrasos, y);
ylim([0 5000]);
title('Ruído: Função de Autocorrelação');

%Filtro Passa Baixa (2kHz): Resposta em Frequência
figure(3)
freqz(filtro)
title('Filtro Passa Baixa: Resposta em Frequência (2kHz)');

%Passando o ruído no filtro Passa Baixa
rf = filter(filtro, 1, r);
%Ruído filtrado no domínio da frequência
RF = fftshift(fft(rf)); 

figure(4)
subplot(211)
plot(t, rf)
title('Ruído filtrado: Domínio do Tempo');

subplot(212)
plot(freq, abs(RF))
title('Ruído filtrado: Domínio da Frequência');

figure(5)
hist(rf, 50);
xlim([-6 6]);
title('Ruído filtrado: Histrograma');