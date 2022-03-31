clear all; clc; close all

y = [0:0.001:1]';
x = 1-y;
M = log(x);

T = log_taylor(x,5);
P = log_pade(x);

ErrorP = P - M;
ErrorT = T - M;

h= figure; 
subplot(211); hold on; grid on; box on
plot(x, M, 'linewidth', 3, 'Color', [0 0 1]); hold on; box on; grid on
plot(x, T, 'linewidth', 3, 'Color', [0 0.7 0]);hold on; box on; grid on
plot(x, P, 'linewidth', 3, 'Color', [1 0.2 0.8])
xlabel('x', 'fontsize', 15); ylabel('$ln (1-x)$', 'fontsize', 15,'Interpreter', 'Latex')
legend({'Matlab', 'Taylor', 'Pade'}, 'location','best');
subplot(212); hold on; grid on; box on
plot(x, ErrorP, 'linewidth', 3, 'Color', [0 0 1]);
plot(x, ErrorT, 'linewidth', 3, 'Color', [0 0.7 0]);
xlabel('x', 'fontsize', 15); ylabel('Error in $ln (1-x)$', 'fontsize', 15,'Interpreter', 'Latex')
legend({'Error - Taylor', 'Error - Pade'}, 'location','best');
filename = ['../../_figures/plotseries']; 
print(h, '-depsc', filename)



function y = log_pade(x)

p = [-0.01812; 0.30555; -1.30555; 2.00000; -1.00000 ; 0];

q = [ -0.00396; 0.11904; -0.83333; 2.22222; -2.50000; 1.00000];

y = polyval1(p,(1-x))./polyval1(q,(1-x));
end

function [y] = polyval1(p,x)

nc = length(p);
siz_x = size(x);
y = zeros(siz_x, superiorfloat(x,p));
if nc>0, y(:) = p(1); end
%horners method
for i=2:nc
    y = x .* y + p(i);
end
end


function logx = log_taylor(x, N)
% x -  a column vector
x = x-1;
logx = zeros(length(x),1);
for n = 1:N
    coeff = (1/n)*(-1)^(n+1)*ones(length(x),1);
    logx    = logx + coeff.*(x.^n);
end
end
