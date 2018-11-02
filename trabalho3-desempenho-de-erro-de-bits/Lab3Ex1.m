clear all; close all; clc;

N = 10; %numero de amostras
SNR = 10;
filtro_nrz = ones(1,N); 
Rb = 1; %taxa de transmissão de bits

info = [0 1 1 0 1 0 1 1 0 1 0];
info_up = upsample(info, N); %superamostragem
info_format = filter(filtro_nrz, 1, info_up); %formatação do sinal

t = [0:length(info_format)-1]/(N*Rb);

Rx = awgn(info_format, SNR, 'measured'); %adicionando ruído branco ao sinal formatado
filtro_casado = filtro_nrz;
Rx_filtrado = filter(filtro_casado, 1, Rx)/N;

figure(1)
subplot(311)
plot(t, info_format); axis([0 11 -0.1 1.1]);
title('Informação');

subplot(312)
plot(t, Rx); xlim([0 11])
title('Informação (recebida) com ruído');
subplot(313)
plot(t, Rx_filtrado); axis([0 11 -0.1 1.1]);
title('Informação após filtragem do ruído');

amostra_filtrado = Rx_filtrado(N:N:end); %metade dos bits até o final
info_hat_filtrado = amostra_filtrado > 0.5; %limiar de decisão
[n_erro_f, taxa_f] = biterr(info, info_hat_filtrado); %compara o sinal original e taxa de erro de bit

amostra_rx = Rx(N:N:end);
info_hat = amostra_rx > 0.5;
[n_erro, taxa] = biterr(info, info_hat);
