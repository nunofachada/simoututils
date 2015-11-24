function pp_plot(file)
% PP_PLOT Plot PPHPC simulation output
%
%   PP_PLOT(file)
%
% Parameters:
%       file  - file containing output of one PPHPC simulation run
%
% Copyright (c) 2015 Nuno Fachada
% Distributed under the MIT License (See accompanying file LICENSE or copy 
% at http://opensource.org/licenses/MIT)
%

% Read stats file
data = dlmread(file);
sheepCountData = data(:, 1);
wolfCountData = data(:, 2);
grassAliveData = data(:, 3);

% Plot population
figure;
hold on;
grid on;
plot(sheepCountData, 'b');
plot(wolfCountData, 'r');
plot(grassAliveData / 4, 'g');
xlim([0 4001]);
h = legend('$P^s_i$', '$P^w_i$', '$P^c_i/4$');
set(h,'interpreter','Latex','FontSize',14);
xlabel('Iterations');
ylabel('Total population');
title('Population');

% Plot energy
avgSheepEnergyData = data(:, 4);
avgWolfEnergyData = data(:, 5);
avgGrassCountdownData = data(:, 6);
figure;
hold on;
grid on;
plot(avgSheepEnergyData, 'b');
plot(avgWolfEnergyData, 'r');
plot(avgGrassCountdownData * 4, 'g');
xlim([0 4001]);
h = legend('$\bar{E}^s_i$', '$\bar{E}^w_i$', '$4 \bar{C}_i$');
%h = legend('$\bar{s}$');
set(h,'interpreter','Latex','FontSize',14);
xlabel('Iterations');
ylabel('Average energy');
title('Energy');
