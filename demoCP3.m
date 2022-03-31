clear all; clc; close all

%.mat file for battery data
data = importdata('C1204_OCV.mat');
id1  = [102:3894]; % to remove preceding charging 
T    = data(id1,3)/3600;
I    = data(id1,7);
V    = data(id1,8);
idxc = find(I>=0);  % charge current
Ic = I(idxc);Tc = T(idxc);
idxd = find(I<0);  %  discharge current
Id = I(idxd); Td = T(idxd);

Qc = sum(diff(Tc).*Ic(2:end)); % charge capacity
Qd = -sum(diff(Td).*Id(2:end)); % discharge capacity

% compute SOC 
SOC = zeros(length(I),1);
SOC(1) = 1; % Assumed that battery is full at start
for i = 2:length(I)
    if I(i) >= 0 
        SOC(i) = SOC(i-1) + (T(i)-T(i-1))*(I(i))/(Qc);
    else
        SOC(i) = SOC(i-1) + (T(i)-T(i-1))*(I(i))/(Qd);
    end
end

E  = .175;     % scaling factor
zs = SOC*(1-2*E) + E; % scaled value of the SOC
N   = length(V);
P   = [ones(N,1) 1./zs 1./zs.^2 1./zs.^3 1./zs.^4 ...
       zs log(zs) log(1 -zs) I]; % combined model
kest = (P'*P)\(P'*V); % LS estimate
R0est = kest(end);
k   = kest(1:8);
OCV = k(1)*ones(length(zs),1) + k(2)*(1./zs) + k(3)*(1./(zs.^2)) + k(4)*(1./(zs.^3)) + ...
    + k(5)*(1./(zs.^4)) + k(6)*(zs) + k(7)*(log(zs)) + k(8)*(log(1-zs));

h=figure; hold on
plot(SOC,V, 'linewidth', 3, 'Color', [0 0 1])
plot(SOC,OCV, 'linewidth', 3, 'Color',  [0 0.7 0])
legend({'Measured Voltage', 'Modeled OCV'}, 'location', 'best')
grid on; box on
xlabel('SOC', 'fontsize', 15);
ylabel('Voltage (V)', 'fontsize', 15);
axis tight


filename = ['../../_figures/ocvsocplot']; 
print(h, '-depsc', filename)


