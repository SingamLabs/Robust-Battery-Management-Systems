
% Copyright 2023 Book - Robust Battery Management Systems (RBMS)
% Dr. Balakumar Balasingam, 
% Associate Professor, University of Windsor
% Email: singam@uwindsor.ca

% Chapter 02 - Review of Math
% Section - III Demonstration of KF implementation. 

%% Measurements

clear; close all; clc

% measurement vector 
zk = [ 6.79 15    21.63 29.23 34.35	35.75 ...
	  42.58 45.26 46.07 46.22 51.11 49.67 ...	
      47.90 49.83 49.17 43.40 47.66 36.63 ...
  	  34.05 35.57 28.98 22.07 16.95	11.79];

% true values of resistance vector
xk = [10.33 16.93 22.93 28.33 33.13	37.33 ...
      40.93	43.93 46.33	48.13 49.33	49.93 ...
      49.93	49.33 48.13	46.33 43.93	40.93 ...
  	  37.33	33.13 28.33	22.93 16.93	10.33];

T = 1; % in hours
t = [1:T:length(zk)]'; % time vector


%% Kalman Filter

% Filter initialization

sig_v = 2; % process noise s.d.
sig_w = 2; % measurement noise s.d.

% observation matrix
H = 1;  

% measurement noise covariance
R = sig_w^2;

% transition matrix
F = 1;      

% process noise covariance
Q = sig_v^2;

% Size allocation
xkf = zeros(1,length(zk));
Pkf = zeros(1, length(zk));
NIS = zeros(1,length(zk)-1);

% Initialization - state
x0 = zk(1);  

% Initialization - covariance
P0 = sig_w^2;

% Saving first state and covariance
xkf(:,1)    = x0;
Pkf(:,:,1)  = P0;

xkk = x0; Pkk = P0;

% KF implementation from time instances 2,3,4,....m
for i = 2:length(zk)
    [xkk, Pkk, NIS(i-1)] = KF(xkk, Pkk, F,Q, H, R, zk(i));

    % Saving state and covariance
    xkf(:,i) = xkk;
    Pkf(:,:,i) = Pkk;
end

% Mean square error for KF state estimate 
MSEkf   = (sum((xkf-xk).^2)/(length(zk)))


%% PLOT 1

% Resistance - Plotting measurement vs estimate
h=figure; hold on; box on; grid on
plot(t, xk,'Color',[0 0 1],'Marker','o','MarkerSize',10,'LineWidth',2)
plot(t, zk,'Color',[0 0.7 0],'Marker','*','MarkerSize',10,'LineStyle','none', 'linewidth', 2)
plot(t, xkf,'Color',[1 0.2 0.8],'MarkerSize',10,'Linewidth',2)

%Plot labels
xlabel('Time index ($k$)','Interpreter','latex','FontSize',15)
ylabel('Resistance (${\rm m} \Omega$)','Interpreter','latex','FontSize',15)
legend({'True', 'Measurement', 'Kalman Filter'},'Location','best')

%saving figure
filename = '../_figures/KFonestate';
% print(h, '-depsc', filename)

%% PLOT 2

% NIS Limits
r1 = 9.8e-4; r2 = 7.4;

% Resistance change - Plotting estimate
h=figure; hold on; box on; grid on
line(t(2:end), r1*ones(size(NIS)),'Linestyle','--', 'Color', [1 0 0],'Linewidth',2)
line(t(2:end), r2*ones(size(NIS)),'Linestyle','--', 'Color', [1 0 0],'Linewidth',2)
plot(t(2:end), NIS, 'LineWidth',2, 'MarkerSize',10,'Color',[0 0 1])

%Plot labels
xlabel('Time index ($k$)','Interpreter','latex','FontSize',15)
ylabel('NIS','Interpreter','latex','FontSize',15)
legend({'lower limit (95%)','upper limit (95%)','NIS'}, 'Location','north')

%saving figure
filename = '../_figures/KFonestateNIS';
%print(h, '-depsc', filename)