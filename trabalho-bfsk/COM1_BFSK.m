%BFSK
%Schaiana Sonaglio


clear all; close all; clc;

%Parâmetros

 tam = 10;
 rb = 1e3;
 n = rb;
 tb = 1/rb;
 freq1 = 10e3;
 freq2 = 50e3;
 ts = tb/n; %tempo de cada amostra
 t = 0:ts:(tam*tb)-ts; 

  
%Informação
info = randint(1,tam);
%Superamostragem
filtro_tx = ones(1,n);
info_mod = info.*4;
info_super = upsample(info_mod,n);
info_tx = filter(filtro_tx, 1, info_super);
info_nrz = filter(filtro_tx, 1, upsample(info,n));

%FSK
fsk = cos(2*pi*freq1*t.*(info_tx+1)); %portadora
figure(1)
subplot(311);
plot(info);
title('Informação');
subplot(312);
plot(t,info_nrz);
ylim([0 1.2]);
title('Informação codificada em NRZ');
subplot(313);
plot(t,fsk);
title('Informação modulada - utilizando portadora)');


%Recebendo a informação
fa = 1/ts;
w = 1/tb; %banda do filtro 

%Frequências
f1 = (freq1-500)./(fa/2);
f2 = (freq1+500)./(fa/2);
fir1_ = fir1(100,[f1 f2]);

f3 = (freq2-500)./(fa/2); 
f4 = (freq2+500)./(fa/2);
fir2_ = fir1(100,[f3 f4]);


%Filtros Passa Faixa
pf1 = filter(fir1_,1,fsk);
pf2 = filter(fir2_,1,fsk);



%Retificando o sinal
ret1 = abs(pf1);
ret2 = abs(pf2);


%Filtros passa baixas
fir3_ = fir1(100,f2,'low');
fir4_ = fir1(100,f4,'low');

pb1 = filter(fir3_,1,ret1);
pb2 = filter(fir4_,1,ret2);

figure(2)
subplot(411)
plot(t,pf1);
hold on;
plot(t,pf2);
hold off;
title('Sinal com filtro passa faixa')
subplot(412)
plot(ret1);
title('Sinal Retificado 1');
subplot(413);
plot(ret2);
title('Sinal Retificado 2');
subplot(414);
plot(t,pb1);
hold on;
plot(t,pb2);
hold off;
title('Sinal com filtro passa baixas')
 
limiar = 0.60;
info_rx = pb2(n:n:end) < limiar;

%super amostrando na recepcao
filtro_rx = ones(1,n);
info_rec = filter(filtro_rx, 1,upsample(info_rx,n));

figure(3)
subplot(311);
plot(info);
title('Informação original');
subplot(312);
plot(info_nrz);
title('Informação NRZ');
subplot(313);
plot(t,info_rec);
title('Informação recebida');