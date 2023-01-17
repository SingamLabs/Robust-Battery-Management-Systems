
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
xekf1 = zeros(1,n); 
Pekf1 = zeros(1,n); NIS1  = zeros(1,n);
xekf2 = zeros(1,n); 
Pekf2 = zeros(1,n); NIS2  = zeros(1,n);


% Initialization - state
x01 = 1;
x02 = 100;

% Initialization - covariance
P01 = 10;
P02 = 10;

% Saving first state and covariance
xkk1 = x01; Pkk1 = P01;
xkk2 = x02; Pkk2 = P02;

xekf1(1) = xkk1; Pekf1(1) = Pkk1; 
xekf2(1) = xkk2; Pekf2(1) = Pkk2; 

% EKF implementation from time instances 2,3,4,....m
for k = 2:n
    [xkk1, Pkk1, NIS1(k)] = EKF(xkk1, Pkk1, Q, R, zk(k), k); 
    [xkk2, Pkk2, NIS2(k)] = EKF(xkk2, Pkk2, Q, R, zk(k), k); 
   
    % Saving state and covariance
    xekf1(k) = xkk1; Pekf1(k) = Pkk1; 
    xekf2(k) = xkk2; Pekf2(k) = Pkk2; 
end

%% PLOT 1

% Plotting measurement vs estimate
h=figure; hold on; box on; grid on
plot(xk, '-ob','Color',[0 0 1], 'linewidth', 2,'MarkerSize',10)
plot(zk, 'Color',[0 0.7 0], 'linewidth', 2,'MarkerSize',10,'LineStyle','none','Marker','*')
plot(xekf1,'Color',[1 0.2 0.8], 'linewidth', 2)
plot(xekf2,'Color',[0 0.6 1], 'linewidth', 2)

%Plot labels
xlabel('Time index, $k$','interpreter', 'latex', 'FontSize', 15) 
legend({'True value $x(k|k)$','Measurement $z (k)$', ...
    'EKF-1', 'EKF-2'},'interpreter', 'latex' ,'location','best') 

%saving figure
filename = '../_figures/EKFestIni';
% print(h, '-depsc', filename)