clear all; close all; clc;

N = 10; %numero de amostras
filtro_nrz = ones(1,N); 
Rb = 1; %taxa de transmissão de bit

info = randi([0 1], 1, 10e3);
info_up = upsample(info, N); %superamostragem
info_format = filter(filtro_nrz, 1, info_up); %formatação do sinal

t = [0:length(info_format)-1]/(N*Rb);

filtro_casado = filtro_nrz;
for SNR = 0:15
    Rx = awgn(info_format, SNR, 'measured');
    %Pb sem filtro
    amostra_Rx = Rx(N:N:end);
    info_hat = amostra_Rx > 0.5;
    [n_erro(SNR+1), taxa(SNR+1)] = biterr(info, info_hat)
    %Pb com filtro
    Rx_filtrado = filter(filtro_casado, 1, Rx)/N;
    amostra_filtrado = Rx_filtrado(N:N:end); %metade dos bits
    info_hat_filtrado = amostra_filtrado > 0.5; %limiar de decisão
    [n_erro_f(SNR+1), taxa_f(SNR+1)] = biterr(info, info_hat_filtrado); %compararando o sinal original e taxa de erro de bit
end

figure(1)
subplot(4,2,1:2)
plot(t, info_format); axis([0 11 -0.1 1.1]);
title('Informação NRZ');
subplot(4,2,3)
plot(t, Rx); xlim([0 11]);
title('Informação com ruído');
subplot(4,2,4)
plot(t, Rx_filtrado); axis([0 11 -0.1 1.1]);
title('Sinal após filtragem do ruído'); 
subplot(4,2,[5 7])
semilogy([0:15], taxa)
title('Probabilidade de erro de bit X SNR Sinal ruidoso');
subplot(4,2,[6 8])
semilogy([0:15], taxa_f)
title('Probabilidade de erro de bit X SNR Sinal pelo filtro casado');