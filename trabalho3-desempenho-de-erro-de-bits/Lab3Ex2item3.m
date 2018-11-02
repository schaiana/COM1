clear all; close all; clc;
N = 10;
filtro_nrz = ones(1,N);
filtro_casado = filtro_nrz;
Rb = 1;

unip = randi([0 1], 1, 10e3);
info_up_unip = upsample(unip, N);
unipolar_format = filter(filtro_nrz, 1, info_up_unip);
t = [0:length(unipolar_format)-1]/(N*Rb);

for SNR = 0:15
    Rx_unipolar = awgn(unipolar_format, SNR, 'measured');
    Rx_unipolar_filtrado = filter(filtro_casado, 1, Rx_unipolar)/N;
    amostra_unip = Rx_unipolar_filtrado(N:N:end);
    info_hat_unipolar = amostra_unip > 0.5;
    [n_erro_unipolar(SNR+1), taxa_unipolar(SNR+1)] = biterr(unip, info_hat_unipolar);
end

bipolar = unip*2 - 1;
info_up_bipolar = upsample(bipolar, N);
bipolar_format = filter(filtro_nrz, 1, info_up_bipolar);
t2 = [0:length(bipolar_format)-1]/(N*Rb);

%Normalização (-1 = 0)
bipolar_norm = bipolar;
find_0 = bipolar_norm == -1;
pos_0 = find(find_0);
bipolar_norm(pos_0) = 0;

for SNR = 0:15
    Rx_bipolar = awgn(bipolar_format, SNR, 'measured');
    Rx_bipolar_filtrado = filter(filtro_casado, 1, Rx_bipolar)/N;
    amostra_bipolar = Rx_bipolar_filtrado(N:N:end);
    info_hat_bipolar = amostra_bipolar > 0;
    [n_erro_bipolar(SNR+1), taxa_bipolar(SNR+1)] = biterr(bipolar_norm, info_hat_bipolar);
end

figure(1)
subplot(5,2,1)
plot(t, unipolar_format); axis([0 11 -0.1 1.1]);
title('Informação NRZ unipolar');
subplot(5,2,2)
plot(t, bipolar_format); axis([0 11 -0.1 1.1]);
title('Informação NRZ bipolar'); axis([0 11 -1.1 1.1]);
subplot(5,2,3)
plot(t, Rx_unipolar); xlim([0 11]);
title('Informação com ruído (unipolar)');
subplot(5,2,4)
plot(t, Rx_bipolar); xlim([0 11]);
title('Informação com ruído (bipolar)');
subplot(5,2,5)
plot(t, Rx_unipolar_filtrado); axis([0 11 -0.1 1.1]);
title('Informação após filtragem do ruído'); 
subplot(5,2,6)
plot(t, Rx_bipolar_filtrado); axis([0 11 -1.1 1.1]);
title('Informação após filtragem do ruído'); 
subplot(5,2,[7 9])
semilogy([0:15], taxa_unipolar)
title('Probabilidade de erro de bit X SNR Unipolar');
subplot(5,2,[8 10])
semilogy([0:15], taxa_bipolar)
title('Probabilidade de erro de bit X SNR Bipolar');