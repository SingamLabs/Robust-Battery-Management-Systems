
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

sig_v = 1; % process noise s.d.
sig_w = 2; % measurement noise s.d.

% observation matrix
H = [1 0];  

% measurement noise covariance
R = sig_w^2;

% transition matrix
F = [1 T;
     0 1];      

% process noise covariance
Q = sig_v^2 * [T^4/4 T^3/2; T^3/2 T^2];

% Size allocation
xkf = zeros(2,length(zk)-1);
Pkf = zeros(2,2,length(zk)-1);

% Initialization - state
x0 = [zk(2); 
      (zk(2)-zk(1))/T]; 

% Initialization - covariance
P0 = sig_w^2 * [1 1/T; 1/T 2/(T^2)];

% Saving first state and covariance
xkf(:,1)    = x0;
Pkf(:,:,1)  = P0;

xkk = x0; Pkk = P0;

% KF implementation from time instances 3,4,....m
for i = 3:length(zk)
    [xkk, Pkk] = KF(xkk, Pkk, F,Q, H, R, zk(i));

    % Saving state and covariance
    xkf(:,i-1) = xkk;
    Pkf(:,:,i-1) = Pkk;
end

% Mean square error for measurement vector
MSEmeas = (sum((zk(2:end)-xk(2:end)).^2)/(length(zk)-1));

% Mean square error for KF state estimate 
MSEkf   = (sum((xkf(1,1:end)-xk(2:end)).^2)/(length(zk)-1));


%% PLOT 1

% Resistance - Plotting measurement vs estimate
h=figure; hold on; box on; grid on
plot(t, xk,'Color',[0 0 1],'Marker','o','MarkerSize',10,'LineWidth',2)
plot(t, zk,'Color',[0 0.7 0], 'linewidth', 2,'Marker','*','MarkerSize',10,'LineStyle','none')
plot(t(2:end), xkf(1,:),'Color',[1 0.2 0.8],'Linewidth',2)

%Plot labels
xlabel('Time index ($k$)','Interpreter','latex','FontSize',15)
ylabel('Resistance (${\rm m} \Omega$)','Interpreter','latex','FontSize',15)
legend({'True', 'Measurement', 'Kalman Filter'},'Location','best')

%saving figure
filename = '../_Ch02figures/02_4_KFest_pos';
% print(h, '-depsc', filename)

%% PLOT 2

% Resistance change - Plotting estimate
h=figure; hold on; box on; grid on
plot(t(2:end), xkf(2,:),'Color',[0 0 1],'Linewidth',2)

%Plot labels
xlabel('Time index ($k$)','Interpreter','latex','FontSize',15)
ylabel('Resistant-change (${\rm m}\Omega$/min)','Interpreter','latex','FontSize',15)

%saving figure
filename = '../_Ch02figures/02_5_KFest_vel';
%print(h, '-depsc', filename)