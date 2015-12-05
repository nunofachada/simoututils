function pp_plot(file, outputs, labels, scale, colors)
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

% Read file containing outputs
data = dlmread(file);

% Default values if respective arguments not given
if nargin < 2
    num_outputs = size(data, 2);
    outputs = cell(1, num_outputs);
    for i = 1:num_outputs
        outputs{i} = ['o' num2str(i)];
    end;
end;
if nargin < 5, colors = {'b', 'r', 'g', 'c', 'm', 'y', 'k'}; end;

% Start plotting outputs
if iscellstr(outputs)
    
    % Plot all outputs in one plot

    if nargin < 3, labels = {'Outputs', 'Time', 'Value'}; end;
    if nargin < 4
        scale = ones(1, numel(outputs));
    elseif numel(scale) == 1
        scale = scale * ones(1, numel(outputs));
    end;

    plot_group_of_outputs(data, outputs, labels, scale, colors);
    
else
    
    if nargin < 3
        labels = cell(1, numel(outputs));
        labels(:) = {{'Outputs', 'Time', 'Value'}}; 
    end;

    % Plot groups of outputs in separate plots
    i1 = 1;
    for outp = outputs
        i2 = i1 + numel(outp) - 1;
        plot_group_of_outputs(data(:, i1:i2), outp, labels{i}, ...
            scale(i1:i2), colors);
        i1 = i2 + 1;
    end;
    
end;


function plot_group_of_outputs(data, outputs, labels, scale, colors)

num_outputs = size(data, 2);
figure();
hold on;
grid on;
for i = 1:num_outputs
    plot(data(:, i), colors{i});
end;

%sheepCountData = data(:, 1);
%wolfCountData = data(:, 2);
%grassAliveData = data(:, 3);

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
