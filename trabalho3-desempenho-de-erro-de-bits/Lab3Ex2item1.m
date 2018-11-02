clear all; close all; clc;

N = 10; %número de amostras
filtro_nrz = ones(1,N);
Rb = 1; %taxa de transmissão de bits

info = randi([0 1], 1, 10e3);
info_2 = info*2;

info_up_1 = upsample(info, N); %superamostragem
info_up_2 = upsample(info_2, N);
info_format_1 = filter(filtro_nrz, 1, info_up_1); %formatacao do sinal
info_format_2 = filter(filtro_nrz, 1, info_up_2);

t = [0:length(info_format_1)-1]/(N*Rb);

for SNR = 0:15
    Rx_1 = awgn(info_format_1, SNR, 'measured');
    Rx_2 = awgn(info_format_2, SNR, 'measured');
    amostra_1 = Rx_1(N:N:end);
    amostra_2 = Rx_2(N:N:end);
    info_hat_1 = amostra_1 > 0.5;
    info_hat_2 = amostra_2 > 1;
    [n_erro_1(SNR+1), taxa_1(SNR+1)] = biterr(info, info_hat_1);
    [n_erro_2(SNR+1), taxa_2(SNR+1)] = biterr(info, info_hat_2);
end
    
figure(1)
subplot(321)
plot(t, info_format_1); axis([0 11 -0.1 1.1]);
title('Informação NRZ 1V');
subplot(322)
plot(t, info_format_2); axis([0 11 -0.1 2.1]);
title('Informação NRZ 2V');
subplot(3,2,[3 5])
semilogy([0:15], taxa_1)
title('Probabilidade de erro de bit X SNR 1V');
subplot(3,2,[4 6])
semilogy([0:15], taxa_2)
title('Probabilidade de erro de bit X SNR 2V');


