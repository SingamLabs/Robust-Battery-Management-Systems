
% Copyright 2023 Book - Robust Battery Management Systems (RBMS)
% Dr. Balakumar Balasingam, 
% Associate Professor, University of Windsor
% Email: singam@uwindsor.ca

% Chapter 02 - Review of Math
% Section - IV Demonstration of EKF implementation. 

%% Measurements

clear; close all; clc

% measurement vector 
zk = [0.623 -0.434 -1.24 9.876 15.272 ...
      9.264 2.375 0.197 10.312 0.095 ...
      1.261 5.689 12.261 8.019 0.349 ...
      0.458 6.306 12.634 12.329 1.039];

% true values
xk = [2.899	3.4570 1.0430 13.568 16.525 ...
      14.689 5.4190 -0.89100 -14.170 -1.8700 ...
  	  -4.8970 -9.6770 -15.346 -13.251 -3.2480 ...
      -0.76300 -12.106 -15.806 -15.111 -5.385];

n=length(zk); %measurement length

%% Kalman Filter

% measurement noise covariance
R = 0.5;

% process noise covariance
Q = 0.1;

% Size allocation
xekf = zeros(1,n);
Pekf = zeros(1,n);
NIS  = zeros(1,n);

% Initialization - state
x0 = 2.4079;

% Initialization - covariance
P0 = 0.2076;

% Saving first state and covariance
xkk = x0; Pkk = P0;

xekf(1) = xkk;
Pekf(1) = Pkk;

% EKF implementation from time instances 2,3,4,....m
for k = 2:n
    [xkk, Pkk, NIS(k)] = EKFmm(xkk, Pkk, Q, R, zk(k), k); 
    
    % Saving state and covariance
    xekf(k) = xkk;
    Pekf(k) = Pkk; 
end

%% PLOT 1

% Plotting measurement vs estimate
h=figure; hold on; box on; grid on
plot(xk, '-ob','Color',[0 0 1], 'linewidth', 2,'MarkerSize',10)
plot(zk, '-xr','Color',[0 0.7 0], 'linewidth', 2,'MarkerSize',10,'LineStyle','none','Marker','*')
plot(xekf,'Color',[1 0.2 0.8], 'linewidth', 2)

%Plot labels
xlabel('Time index, k', 'fontsize', 15,'Interpreter','latex') 
legend({'True value $x(k|k)$','Measurement $z (k)$', ...
    'Estimate $\hat x(k|k)$ '},'interpreter', 'latex' ) 

%saving figure
filename = '../_figures/EKFmismatch';
% print(h, '-depsc', filename)

%% PLOT 2

% NIS Limits
r1 = 9.8e-4; r2 = 7.4;

% Plotting estimate
h=figure; hold on; box on; grid on
line(1:length(NIS), r1*ones(size(NIS)),'Linestyle','--', 'Color', [1 0 0],'Linewidth',2)
line(1:length(NIS), r2*ones(size(NIS)),'Linestyle','--', 'Color', [1 0 0],'Linewidth',2)
plot(NIS,'Color',[0 0 1], 'linewidth', 2)

%Plot labels
xlabel('Time index, k', 'fontsize', 15,'Interpreter','latex')
ylabel('NIS', 'fontsize', 15)

%saving figure
filename = '../_figures/EKFmismatchNIS';
%print(h, '-depsc', filename)