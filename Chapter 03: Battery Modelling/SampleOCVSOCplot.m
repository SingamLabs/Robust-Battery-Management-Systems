clear all; clc; close all 
% filename:SampleOCVSOCplot.m 
% Creates OCV-SOC plot
% Uses Combined+3 model and scaling
k0 = -9.082; k1 = 103.087;
k2 = -18.185; k3 = 2.062;
k4 = -0.102; k5 = -76.604;
k6 =  141.199; k7 = -1.117;
SOC = 0:.0001:1; 
epsilon = 0.175;
zs = SOC*(1-2*epsilon) + epsilon; 
OCV = k0*ones(size(SOC)) ...
    + k1*(1./zs) + k2*(1./(zs.^2)) ...
    + k3*(1./(zs.^3)) + k4*(1./(zs.^4))...
    + k5*(zs) + k6*(log(zs))...
    + k7*(log(1-zs));  
plot(SOC, OCV)



   






