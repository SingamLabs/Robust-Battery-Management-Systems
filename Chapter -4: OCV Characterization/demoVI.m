clear all; close all; clc

%.mat file for battery data
filename = 'C1204_OCV.mat'; data = importdata(filename);
id1 = [102:3894];
% Extracting the Time, Voltage(V) and Current(I) columns from the stored data
Time = data(id1,3)/3600;
I    = data(id1,7);
V    = data(id1,8);
[SOC, Time, I] = CoulombCount_SOC(Time, I);
id2 = [1:1860 1929:length(SOC)];
%Extracting SOC data between 0 and 1
SOC = SOC(id2); Time = Time(id2);
I   = I(id2); Vin  = V(id2); 

h= figure; 
subplot(211); hold on; grid on; box on
plot(Time, Vin, 'linewidth', 3, 'Color', [0 0 1]);
xlabel('Time (sec)', 'fontsize', 15); ylabel('Voltage (V)', 'fontsize', 15)
xlim([0 Time(end)])    
 
subplot(212); hold on; grid on; box on
plot(Time, I, 'linewidth', 3, 'Color', [0 0 1]);
xlabel('Time (sec)', 'fontsize', 15); ylabel('Current (A)', 'fontsize', 15)
xlim([0 Time(end)])    

filename = ['../../_figures/VIplot']; 
print(h, '-depsc', filename)
