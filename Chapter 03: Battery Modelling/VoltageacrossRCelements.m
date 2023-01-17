clear all; clc; close all

k0 = -9.082; k1 = 103.087; k2 = -18.185;
k3 = 2.062; k4 = -0.102; k5 = -76.604;
k6 = 141.199;  k7 = -1.117;
Kbatt = [k0; k1; k2; k3; k4; k5; k6; k7];

Batt.Kbatt = Kbatt; Batt.Cbatt = 1.5;
Batt.R0 = .2; Batt.R1 = .1;
Batt.C1 = 2;  Batt.R2 = .3;
Batt.C2 = 5; Batt.ModelID = 4;
Batt.SOC = 1; Batt.SOCsf = 0.175;

% store current values in an array
delta = 0.01;
T = 0.01:delta:5;
I = -40*ones(1,length(T));
idx = find((T>1&T<2)|(T>3&T<4));
I(idx) = -120; I = I'/1000; 

% Question 1 Plot
h1 = figure; box on; grid on; hold on
plot(T,1000*I,'LineWidth',2)
xlabel('Time (s)')
ylabel('Current (mA)')


% (1) Ideal battery model
Batt.ModelID = 2;
Batt.R0      = 0;
[V1] = battSIM(I, Batt, delta);
h=figure; box on; grid on; hold on
plot(T,V1,'LineWidth',3,'Color', [0 0 1])
% (2) R-int mode1
Batt.R0      = .2;
[V2] = battSIM(I, Batt, delta);
plot(T,V2,'LineWidth',3,'Color',[0 0.7 0], 'LineStyle','--')
% (3) 1RC model
Batt.ModelID = 3;
[V3] = battSIM(I, Batt, delta);
plot(T,V3,'LineWidth',3,'Color',[1 0.2 0.8], 'LineStyle',':')
% (4) 2RC model
Batt.ModelID = 4;
[V4] = battSIM(I, Batt, delta);
plot(T,V4,'LineWidth',3,'Color',[0 0.6 1], 'LineStyle','-.')

xlabel('Time (s)', 'fontsize', 15); ylabel('Voltage (V)', 'fontsize', 15)
legend({'Ideal','R-int','1RC','2RC'},'location', 'best')
filename = '../../_figures/DCECMdemo';
print(h, '-depsc', filename)
