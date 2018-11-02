%Laboratório modulações digitais
%Schaiana Sonaglio
%Exercício 3

close all; clear all; clc;

%Parâmetros
n = 10e6;
SNR = 10;

%Gerando a informações
info_2 = randint(1,n,2); %BPSK
info_4 = randint(1,n,4); %QPSK
info_8 = randint(1,n,8); %8PSK
info_16 = randint(1,n,16); %16PSK

%Ajustando potência
scale_2 = modnorm(pskmod([0:2-1],2),'avpow',2); %BPSK
scale_4 = modnorm(pskmod([0:4-1],4),'avpow',4); %BPSK
scale_8 = modnorm(pskmod([0:8-1],8),'avpow',8); %BPSK
scale_16 = modnorm(pskmod([0:16-1],16),'avpow',16); %BPSK

%PSK
psk_2 = pskmod(info_2,2) .* scale_2; %BPSK
psk_4 = pskmod(info_4,4).* scale_4; %QPSK
psk_8 = pskmod(info_8,8) .* scale_8; %8PSK
psk_16 = pskmod(info_16,16) .* scale_16; %16PSK

%Variando a SNR
for x = 0:SNR
    rec2 = awgn(psk_2,x); 
    demod2 = pskdemod(rec2/scale_2,2);
    [n2(x+1),t2(x+1)]=symerr(info_2,demod2); %BPSK
    
    rec4 = awgn(psk_4,x); 
    demod4 = pskdemod(rec4/scale_4,4);
    [n4(x+1),t4(x+1)]=symerr(info_4,demod4); %QPSK
    
    rec8 = awgn(psk_8,x); 
    demod8 = pskdemod(rec8/scale_8,8);
    [n8(x+1),t8(x+1)]=symerr(info_8,demod8); %8PSK
    
    rec16 = awgn(psk_16,x); 
    demod16 = pskdemod(rec16/scale_16,16);
    [n16(x+1),t16(x+1)]=symerr(info_16,demod16); %16PSK      
end

%Plots
figure(1)
semilogy([0:SNR],t2,[0:SNR],t4,[0:SNR],t8,[0:SNR],t16);
ylabel('SER');xlabel('SNR[dB]');
legend('BPSK','QPSK','8PSK','16PSK')
title('Comparação entre o desempenho das modulações MPSK')
