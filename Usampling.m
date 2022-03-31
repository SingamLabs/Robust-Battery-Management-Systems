clear all; clc; close all
x = -3:.001:10;
y = sin(x) + .002*sin(-4*x) + .6*cos(.4*x);
h = figure;hold on; box on; grid on
plot (x,y, 'linewidth', 3, 'Color', [0 0 1]); hold on; box on; grid on
ylim([-1.7 1.7]); yticks(['']);
xlim([-3 10]); 
xticks([-2.3 -00.171 2.16 4.381 6.42 8.2723 9.957])
xticklabels({'x1','x2','x3','x4','x5','x6','x7'});
ylabel('f(x)','fontsize',14)
xlabel('$\mathcal{X}$', 'Interpreter', 'Latex', 'fontsize', 15)
fifth = [-2.3399000000000000,-0.3809169434660837];
fourth = [2.1600000000000,1.21737619930394];
third = [4.38100000000000,-1.0533747831167254];
second = [8.276000000000000,0.3267847076713612];
first = [9.95700000000000,-0.909083795516733];

plot([first(1) second(1)],[first(2) second(2)],'linewidth', 3, 'Color', [0 0.7 0])
plot([second(1), third(1)],[second(2), third(2)],'linewidth', 3, 'Color', [0 0.7 0])
plot([third(1) fourth(1)],[third(2) fourth(2)],'linewidth', 3, 'Color', [0 0.7 0])
plot([fourth(1) fifth(1)],[fourth(2) fifth(2)],'linewidth', 3, 'Color',[0 0.7 0])

filename = '../_figures/UsamplingPlot';
print(h, '-depsc', filename)