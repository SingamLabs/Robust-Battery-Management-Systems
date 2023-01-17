
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

sig_v1 = 1; % process noise s.d.
sig_v2 = sqrt(.01); % process noise s.d.
sig_w = 2; % measurement noise s.d.

% observation matrix
H = [1 0];  

% measurement noise covariance
R = sig_w^2;

% transition matrix
F = [1 T;
     0 1];      

% process noise covariance
Q1   = sig_v1^2 * [T^4/4 T^3/2; T^3/2 T^2];
Q2   = sig_v2^2 * [T^4/4 T^3/2; T^3/2 T^2];

% Size allocation
xkf1 = zeros(2,length(zk)-1);
Pkf1 = zeros(2,2,length(zk)-1);
NIS1 = zeros(1,length(zk)-2);

xkf2 = zeros(2,length(zk)-1);
Pkf2 = zeros(2,2,length(zk)-1);
NIS2 = zeros(1,length(zk)-2);

% Initialization - state
x0 = [zk(2); 
      (zk(2)-zk(1))/T]; 

% Initialization - covariance
P0 = sig_w^2 * [1 1/T; 1/T 2/(T^2)];

% Saving first state and covariance
xkf1(:,1) = x0; Pkf1(:,:,1) = P0;
xkf2(:,1) = x0; Pkf2(:,:,1) = P0;

xkk1 = x0; Pkk1 = P0;
xkk2 = x0; Pkk2 = P0;

% KF implementation from time instances 3,4,....m
for i = 3:length(zk)
    [xkk1, Pkk1, NIS1(i-2)] = KF(xkk1, Pkk1, F,Q1, H, R, zk(i));
    [xkk2, Pkk2, NIS2(i-2)] = KF(xkk2, Pkk2, F,Q2, H, R, zk(i));

    % Saving state and covariance
    xkf1(:,i-1) = xkk1; Pkf1(:,:,i-1) = Pkk1;
    xkf2(:,i-1) = xkk2; Pkf2(:,:,i-1) = Pkk2;
end

% Mean square error for KF state estimate 
MSEkf   = (sum((xkf2(1,1:end)-xk(2:end)).^2)/(length(zk)-1))


%% PLOT 1

% Resistance - Plotting measurement vs estimate (KF1 and KF2)
h=figure; hold on; box on; grid on
plot(t, xk,'Color',[0 0 1],'Marker','o','MarkerSize',10,'LineWidth',2)
plot(t(2:end), xkf1(1,:),'Color',[0 0.7 0],'Linewidth',2,'MarkerSize',10)
plot(t(2:end), xkf2(1,:),'Color',[1 0.2 0.8],'Linewidth',2)

%Plot labels
xlabel('Time index ($k$)','Interpreter','latex','FontSize',15)
ylabel('Resistance (${\rm m} \Omega$)','Interpreter','latex','FontSize',15)
legend({'True','KF1','KF2'}, 'location','best')

%saving figure
filename = '../_figures/KFperformance1';
%print(h, '-depsc', filename)

%% PLOT 2

% NIS Limits
r1 = 9.8e-4; r2 = 7.4;

% Resistance change - Plotting estimate
h=figure; hold on; box on; grid on
line(t(3:end), r1*ones(size(NIS1)),'Linestyle','--', 'Color', [1 0 0],'Linewidth',2)
line(t(3:end), r2*ones(size(NIS1)),'Linestyle','--', 'Color', [1 0 0],'Linewidth',2)
plot(t(3:end), NIS1, 'LineWidth',2,'Color',[0 0 1])
plot(t(3:end), NIS2, 'LineWidth',2,'Color',[0 0.7 0])

%Plot labels
xlabel('Time index ($k$)','Interpreter','latex','FontSize',15)
ylabel('NIS','Interpreter','latex','FontSize',15)
legend({'lower limit (95%)','upper limit (95%)','KF1','KF2'}, 'Location','best')

%saving figure
filename = '../_figures/KFperformance2';
%print(h, '-depsc', filename)