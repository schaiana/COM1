%Laboratório modulações digitais
%Schaiana Sonaglio
%Exercício 5

close all; clear all; clc;

%Parâmetros
n = 10e6;
SNR = 10;

%Gerando as informações
info_16 = randint(1,n,16); %16PSK, 16QAM

%PSK
scale_16=modnorm(pskmod([0:16-1],16),'avpow',16);
psk16 = pskmod(info_16,16)*scale_16;

%QAM
qam_16 = qammod(info_16,16);

%Variando a SNR

for x = 0:SNR        
    psk_demod = pskdemod(awgn(psk16,x)/scale_16,16);
    [npsk(x+1),tpsk(x+1)]=symerr(info_16,psk_demod);
    
    qam_demod = qamdemod(awgn(qam_16,x),16);
    [nqam(x+1),tqam(x+1)]=symerr(info_16,qam_demod);    
   
end

%Plot
figure(1)
semilogy([0:SNR],tpsk,[0:SNR],tqam);
title('Comparação entre o desempenho de uma modulação 16PSK e 16QAM')
ylabel('SER');xlabel('SNR[dB]');
legend('PSK','QAM') 


