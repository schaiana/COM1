%Laboratório modulações digitais
%Schaiana Sonaglio
%Exercício 6

%Modulador QAM
%Parâmetros
k = 4;
M = 2^k;
fc = 4e3;
up = 100;
fa = 10*fc;
tam = 100;  

%Gerando as informações
info_bin = randi([0 1],1,tam);
info_mat = vec2mat(info_bin,k);

%Binário para decimal
info_dec = bi2de(info_mat)';
qam = qammod(info_dec,M);

%Separando parte imaginária e parte real
real_qam = real(qam);
imag_qam = imag(qam);


%NRZ
filtrotx = ones(1,up);
real_nrz = filter(filtrotx,1, upsample(real_qam,up));
imag_nrz = filter(filtrotx,1, upsample(imag_qam,up));

%Vetor de tempo
v = length(real_nrz)/fa-(1/fa);
t1 = [0:1/fa:v];


%Informação modulada
real_tx = real_nrz.*cos(2*pi*fc*t1);
imag_tx = imag_nrz.*-sin(2*pi*fc*t1);
info_modulada = real_tx + imag_tx;

%Representando em números complexos
%NRZ 
qam_i = filter(filtrotx,1, upsample(qam,up));
qam_modulado_i = qam_i.*exp(j*2*pi*fc*t1);
info_modulada_i = real(qam_modulado_i);


figure(1);
subplot(811);
plot(t1,real_nrz);
title('Parte real do sinal')
subplot(812);
plot(t1,imag_nrz);
title('Parte imaginária do sinal')
subplot(813);
plot(t1,info_modulada);
title('Informação modulada')
subplot(814);
plot(t1,info_modulada_i);
title('Informação modulada complexa')


%Demodulador QAM
info_rec = info_modulada;

%Separando parte imaginária e parte real
info_real_rec = info_rec.*cos(2*pi*fc*t1);
info_imag_rec = info_rec.*-1.*sin(2*pi*fc*t1);


subplot(815);
plot(t1,info_real_rec);
title('Parte real do sinal recebido no demodulador')
subplot(816);
plot(t1,info_imag_rec);
title('Parte imaginária do sinal recebido no demodulador')

%Filtro Passa Baixas
wc = (fc)./(fa/2);
fir1_b = fir1(40,wc,'low'); 
sinal_real_filtrado = (filter(fir1_b,1,info_real_rec))*2;
sinal_imag_filtrado = (filter(fir1_b,1,info_imag_rec))*2;

subplot(817);
plot(t1,sinal_real_filtrado);
title('Parte real do sinal recebido e filtrado')
subplot(818);
plot(t1,sinal_imag_filtrado);
title('Parte imaginária do sinal recebido e filtrado')

%Amostrando
sinal_real_rx = sinal_real_filtrado(up:up:end);
sinal_imag_rx = sinal_imag_filtrado(up:up:end);

%Colocando em número complexo
sinal_complexo = sinal_real_rx + (j*sinal_imag_rx);

%Demodulando
demod = qamdemod(sinal_complexo,M);

figure(2)
subplot(611);
stem(info_dec);
title('Sinal modulado')
subplot(612);
stem(demod);
title('Sinal demodulado')

%Demodulador complexo
info_rec_complexa = info_modulada_i;

%multiplicando pela portadora
info_rec_real_complexa = (info_rec_complexa.*exp(-1j*2*pi*fc*t1))*2;

subplot(613);
plot(t1,info_rec_real_complexa);
title('Sinal recebido - complexo')

%filtro PB
fir_complexo = fir1(40,wc,'low');  
sinal_complexo_filtrado = filter(fir_complexo,1,info_rec_real_complexa);

subplot(614);
plot(t1,sinal_complexo_filtrado);

%Amostrando
rx_complexo = sinal_complexo_filtrado(up:up:end);
% 
%Demodulando
demod_complexo = qamdemod(rx_complexo,M);

subplot(615);
stem(demod_complexo);
title('Sinal transmitido')
subplot(616);
stem(info_dec);
title('Sinal recebido demodulado - complexo')








