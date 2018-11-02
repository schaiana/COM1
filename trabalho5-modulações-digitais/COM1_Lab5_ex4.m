%Laboratório modulações digitais
%Schaiana Sonaglio
%Exercício 4

close all; clear all; clc;

%Parâmetros
n = 10e6;
SNR = 10;

%Gerando a informações
info_4 = randint(1,n,4); %4QAM
info_16 = randint(1,n,16); %16QAM
info_64 = randint(1,n,64); %64QAM

%QAM
qam_4 = qammod(info_4,4);
qam_16 = qammod(info_16,16);
qam_64 = qammod(info_64,64);

%Variando a SNR
for x = 0:SNR        
    demod_4 = qamdemod(awgn(qam_4,x),4);
    [n4(x+1),t4(x+1)]=symerr(info_4,demod_4);    
    demod_16 = qamdemod(awgn(qam_16,x),16);
    [n16(x+1),t16(x+1)]=symerr(info_16,demod_16);
    demod_64 = qamdemod(awgn(qam_64,x),64);
    [n64(x+1),t64(x+1)]=symerr(info_64,demod_64);
end

%Plot
figure(1)
semilogy([0:SNR],t4,[0:SNR],t16,[0:SNR],t64);
title('Comparação entre o desempenho das modulações MQAM')
ylabel('SER');xlabel('SNR[dB]');
legend('4QAM','16QAM','64QAM')
