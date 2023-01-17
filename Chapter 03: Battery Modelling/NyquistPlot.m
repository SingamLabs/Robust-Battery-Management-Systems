clear all; clc; close all
% file name: `NyquistPlot.m'
% initialize AC-ECM model parameters
R_Omega = 0.5; R_SEI = 0.1;  C_SEI = 0.2; 
R_CT = .5; C_DL = 100; L= 4e-6; Sig = 0.005;
% create frequency array 
fmin = .00001; fmax = 1000; frange = [];
for i=1:ceil(log10(fmax/fmin))
    fr = fmin:fmin/4:10*fmin;
    frange = [frange fr];
    fmin = 10*fmin;
end
w = 2*pi*frange; % angular frequency
Zw = Sig*sqrt(2./(j*w)); % Warburg Imp.
Z = j*w*L + R_Omega  + ...
    1./(1./(R_CT+Zw)+j*w*C_DL)+ ...
    1./(1/R_SEI+j*w*C_SEI);  
plot(real(Z), -imag(Z))% Nyquist plot

h = figure; hold on; grid on; box on;
plot(real(Z), -imag(Z), 'linewidth', 3, 'Color', [0 0 1])
xlabel('Re($Z_w(\omega)$)', 'Interpreter', 'Latex', 'fontsize', 15)
ylabel('Im($Z_w(\omega)$)', 'Interpreter', 'Latex', 'fontsize', 15)
xlim([R_Omega-.1 max(real(Z))+.1])
filename = '../../_figures/NyquistPlot'
print(h, '-depsc', filename)

