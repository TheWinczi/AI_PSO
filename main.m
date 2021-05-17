clear all
clc

disp('PSO algorith implementation');

% arguments for algorithms
pop_size = 100;
iterations = 20;
w = 10*rand(pop_size, 2) - 5;

% shwoing functions
[x, y]=meshgrid(-5:0.05:5);
z=funea(x,y);
surf(x,y,z);
title('main function');
pause;
close;

% starting algotyhms
disp('ALGORYTM ROJOWY');
pso_alg(pop_size, iterations, w);