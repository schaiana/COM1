clear all; close all; clc;

%%Carregando o áudio
samples =[1, 5*44100];
[d,Fs] = audioread('arctic_monkeys.mp3',samples);

t = 0:seconds(1/Fs):seconds(5);
t = t(1:end-1);

%%Definindo os parâmetros
k1 = 3; k2 = 5; k3 = 8; k4 = 13; N = 10;
SNR1 = 0; SNR2 = 15; SNR34 = 100;
L1 = 2^k1; L2 = 2^k2; L3 = 2^k3; L4 = 2^k4;
max = 1; min = -1;

vpp = max - min;

d1 = vpp/L1;
d2 = vpp/L2;
d3 = vpp/L3;
d4 = vpp/L4;

d_desloc = d+1; %deslocamento do sinal

%%Quantizando
quant1 = round(d_desloc/d1);
quant2 = round(d_desloc/d2);
quant3 = round(d_desloc/d3);
quant4 = round(d_desloc/d4);

%%Convertendo de decimal para binário e fazendo reshape
conv1 = de2bi(quant1);
conv2 = de2bi(quant2);
conv3 = de2bi(quant3);
conv4 = de2bi(quant4);

reshape1 = reshape(conv1,1,length(quant1)*(k1+1));
reshape2 = reshape(conv2,1,length(quant2)*(k2+1));
reshape3 = reshape(conv3,1,length(quant3)*(k3+1));
reshape4 = reshape(conv4,1,length(quant4)*(k4+1));

%%Codificação em NRZ bipolar: transformando 0 em -1 e 1 em 1
conv_valores1 = (2.*reshape1)-1;
conv_valores2 = (2.*reshape2)-1;
conv_valores3 = (2.*reshape3)-1;
conv_valores4 = (2.*reshape4)-1;
cod_nrz1 = rectpulse(conv_valores1,N);
cod_nrz2 = rectpulse(conv_valores2,N);
cod_nrz3 = rectpulse(conv_valores3,N);
cod_nrz4 = rectpulse(conv_valores4,N);

%%Adicionando ruído
cod_nrz1_awgn = awgn(cod_nrz1,SNR1);
cod_nrz2_awgn = awgn(cod_nrz2,SNR2);
cod_nrz3_awgn = awgn(cod_nrz3,SNR34);
cod_nrz4_awgn = awgn(cod_nrz4,SNR34);

%%Recepcionando o sinal
rx1 = cod_nrz1_awgn;
rx2 = cod_nrz2_awgn;
rx3 = cod_nrz3_awgn;
rx4 = cod_nrz4_awgn;
l = 0; %pois ta entre -1 e 1

am_cod_nrz1_awgn = rx1(N/2:N:end); %pegar as amostragens corretamente
am_cod_nrz2_awgn = rx2(N/2:N:end);
am_cod_nrz3_awgn = rx3(N/2:N:end);
am_cod_nrz4_awgn = rx4(N/2:N:end);
decod1 = am_cod_nrz1_awgn > l;
decod2 = am_cod_nrz2_awgn > l;
decod3 = am_cod_nrz3_awgn > l;
decod4 = am_cod_nrz4_awgn > l;

%%Decodificando
rx_bin1 = bi2de(reshape(decod1,length(quant1),(k1+1)));
rx_bin2 = bi2de(reshape(decod2,length(quant2),k2+1));
rx_bin3 = bi2de(reshape(decod3,length(quant3),(k3+1)));
rx_bin4 = bi2de(reshape(decod4,length(quant4),k4+1));
rx1 = rx_bin1*d1;
rx2 = rx_bin2*d2;
rx3 = rx_bin3*d3;
rx4 = rx_bin4*d4;
rx_rec1 = rx1-1;
rx_rec2 = rx2-1;
rx_rec3 = rx3-1;
rx_rec4 = rx4-1;

%%Plots
figure(1);
subplot(511);
plot(d);
title('Sinal original');
subplot(512);
plot(cod_nrz1);
title('Sinal - NRZ bipolar - 3 bits');
ylim([-2 2]);

subplot(513);
plot(cod_nrz2);
title('Sinal - NRZ bipolar - 5 bits');
ylim([-2 2]);

subplot(514);
plot(cod_nrz3);
title('Sinal - NRZ bipolar - 8 bits');
ylim([-2 2]);

subplot(515);
plot(cod_nrz4);
title('Sinal - NRZ bipolar - 13 bits');
ylim([-2 2]);

figure(2);
subplot(411);
plot(rx1);
title('Sinal recebido - k = 3 bits; SNR = 0');
subplot(412);
plot(rx_rec1);
title('Sinal recuperado - k = 3 bits; SNR = 0');

subplot(413);
plot(rx2);
title('Sinal recebido - k = 5 bits; SNR = 5');
subplot(414);
plot(rx_rec2);
title('Sinal recuperado - k = 5 bits; SNR = 5');

figure(3);
subplot(411);
plot(rx3);
title('Sinal recebido - k = 8 bits; SNR = 100');
subplot(412);
plot(rx_rec3);
title('Sinal recuperado - k = 8 bits; SNR = 100 ');

subplot(413);
plot(rx4);
title('Sinal recebido - k = 13 bits; SNR = 100');

subplot(414);
plot(rx_rec4);
title('Sinal recuperado - k = 13 bits; SNR = 100');

%%Ouvindo os sons recuperados
%sound(rx_rec1,Fs);
%sound(rx_rec2,Fs);
%sound(rx_rec3,Fs);
%sound(rx_rec4,Fs);