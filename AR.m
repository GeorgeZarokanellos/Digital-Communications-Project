%code that executes PCM on AR_1(1) and AR_2(1) on 2,4 and 8 bits as well as ADM.
%Graphs the differentiation in SQNR in each iteration in each number of
%bits
%Graphs the output waveforms compared to the input ones 
%Displays the entropy, and deformation of PCM and the sqnr and entropy of
%ADM

x = randn(10000,1);     %produce white noise
a1 = 0.9;       %coefficient of AR_1(1)
a2 = 0.01;      %coefficient of AR_2(1)
a_1 = [1 -a1];
a_2 = [1 -a2];
y_1 = filter(1,a_1,x);      %create AR(1)
y_2 = filter(1,a_2,x);     %create AR(2)
y_1_min = min(y_1);
y_1_max = max(y_1);
y_2_min = min(y_2);
y_2_max = max(y_2);
n1 = 2;
n2 = 4;
n3 = 8;
select = 1;
M = 4;
figure(1);
[y_q1,levels_1,D_1,zone_limits_1] = LloydMax(y_1,n1,y_1_min,y_1_max);
title("Differentiation of SQNR of AR_1(1) in each iteration of Lloyd-Max ");
figure(2);
[y_q2,levels_2,D_2,zone_limits_2] = LloydMax(y_1,n2,y_1_min,y_1_max);
title("Differentiation of SQNR of AR_1(1) in each iteration of Lloyd-Max ");
figure(3);
[y_q3,levels_3,D_3,zone_limits_3] = LloydMax(y_1,n3,y_1_min,y_1_max);
title("Differentiation of SQNR of AR_1(1) in each iteration of Lloyd-Max ");

figure(4);
stairs(y_1);
hold on;
stairs(y_q1);
hold off;
xlabel("number of point");
ylabel("value of point");
title("2-bit PCM on AR_1(1)");
legend('original' , 'quantized');

figure(5);
stairs(y_1);
hold on;
stairs(y_q2);
hold off;
xlabel("number of point");
ylabel("value of point");
title("4-bit PCM on AR_1(1)");
legend('original' , 'quantized');

figure(6);
stairs(y_1);
hold on;
stairs(y_q3);
hold off;
xlabel("number of point");
ylabel("value of point");
title("8-bit PCM on AR_1(1)");
legend('original' , 'quantized');

y_1 = interp(y_1,M);
[y_q4,y_b1,steps_1] = ADM(y_1);


figure(7)
stairs(y_1);
hold on;
stairs(y_q4);
hold off;
xlabel("number of point");
ylabel("value of point");
title("ADM on AR_1(1)");
legend('original' , 'quantized');


figure(8);
[y_q5,levels_4,D_4,zone_limits_4] = LloydMax(y_2,n1,y_2_min,y_2_max);
title("Differentiation of SQNR of AR_2(1) in each iteration of Lloyd-Max ");
figure(9);
[y_q6,levels_5,D_5,zone_limits_5] = LloydMax(y_2,n2,y_2_min,y_2_max);
title("Differentiation of SQNR of AR_2(1) in each iteration of Lloyd-Max ");
figure(10);
[y_q7,levels_6,D_6,zone_limits_6] = LloydMax(y_2,n3,y_2_min,y_2_max);
title("Differentiation of SQNR of AR_2(1) in each iteration of Lloyd-Max ");

figure(11);
stairs(y_2);
hold on;
stairs(y_q5);
hold off;
xlabel("number of point");
ylabel("value of point");
title("2-bit PCM on AR_2(1)");
legend('original' , 'quantized');

figure(12);
stairs(y_2);
hold on;
stairs(y_q6);
hold off;
xlabel("number of point");
ylabel("value of point");
title("4-bit PCM on AR_2(1)");
legend('original' , 'quantized');

figure(13);
stairs(y_2);
hold on;
stairs(y_q7);
hold off;
xlabel("number of point");
ylabel("value of point");
title("8-bit PCM on AR_2(1)");
legend('original' , 'quantized');

y_2 = interp(y_2,M);
[y_q8,y_b2,steps_2] = ADM(y_2);

figure(14)
stairs(y_2);
hold on;
stairs(y_q8);
hold off;
xlabel("number of point");
ylabel("value of point");
title("ADM on AR_2(1)");
legend('original' , 'quantized');







