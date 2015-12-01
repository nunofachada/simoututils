function d = pp_plot_many(folder, files, iters, type)
% PP_PLOT_MANY Plot PPHPC simulation output from a number of runs, either
% 1) with superimposed outputs, 2) plot filled area encompassed by output
% extremes, or, 3) moving average plot.
%
%   PP_PLOT_MANY(folder, files, iters, type)
%
% Parameters:
%     folder - Folder containing simulation output files.
%      files - Simulation output files (use wildcards).
%      iters - Number of iterations to plot.
%       type - Type of plot:
%            'a' - Superimposed outputs.
%            'f' - Plot filled area encompassed by output extremes.
%          0...w - Moving average, window size w
%
% Outputs:
%    d - Tri-dimensional matrix containing what was plotted. First 
%        dimension corresponding to the replication number if type='a', 
%        to the extremes (min and max) if type='f', or to the single
%        moving average if type is numeric. Second dimension corresponds to
%        iterations. Third dimension corresponds to outputs.
%
%
% Copyright (c) 2015 Nuno Fachada
% Distributed under the MIT License (See accompanying file LICENSE or copy 
% at http://opensource.org/licenses/MIT)
%

listing = dir([folder '/' files]);

numFiles = size(listing, 1);

% Initialize data vectors
sheepData = zeros(iters, numFiles);
wolfData = zeros(iters, numFiles);
grassData = zeros(iters, numFiles);
avgSheepEnergyData = zeros(iters, numFiles);
avgWolfEnergyData = zeros(iters, numFiles);
avgGrassCountdownData = zeros(iters, numFiles);

% Read results files
for i = 1:numFiles
    
    data = dlmread([folder '/' listing(i).name]);
    sheepData(:, i) = data(:, 1);
    wolfData(:, i) = data(:, 2);
    grassData(:, i) = data(:, 3);    
    avgSheepEnergyData(:, i) = data(:, 4);
    avgWolfEnergyData(:, i) = data(:, 5);
    avgGrassCountdownData(:, i) = data(:, 6);
    
end;

% Create figures
pop_fig = figure();
hold on; grid on;

en_fig = figure();
hold on; grid on;
    
if type == 'a' % Many
    
    % Initialize output matrix
    d = zeros(numFiles, iters, 6);
    
    for i = 1:numFiles
        
        % Plot data
        figure(pop_fig);
        plot(sheepData(:, i), 'b');
        plot(wolfData(:, i), 'r');
        plot(grassData(:, i) ./ 4, 'g');
        
        figure(en_fig);
        plot(avgSheepEnergyData(:, i), 'b');
        plot(avgWolfEnergyData(:, i), 'r');
        plot(avgGrassCountdownData(:, i) * 4, 'g');
        
        % Fill the output matrix
        d(i, :, :) = [sheepData(:, i) wolfData(:, i) grassData(:, i) ...
            avgSheepEnergyData(:, i) avgWolfEnergyData(:, i) avgGrassCountdownData(:, i)];
        
    end;

elseif type == 'f' % Filled
    
    % Find extremes
    extSheepData = [min(sheepData, [], 2) max(sheepData, [], 2)];
    extWolfData = [min(wolfData, [], 2) max(wolfData, [], 2)];
    extGrassData = [min(grassData, [], 2) max(grassData, [], 2)];
    extAvgSheepEnergyData = [min(avgSheepEnergyData, [], 2) max(avgSheepEnergyData, [], 2)];
    extAvgWolfEnergyData = [min(avgWolfEnergyData, [], 2) max(avgWolfEnergyData, [], 2)];
    extAvgGrassCountdownData = [min(avgGrassCountdownData, [], 2) max(avgGrassCountdownData, [], 2)];
    
    % Initialize output matrix
    d = zeros(2, iters, 6);
    
    % Fill output matrix
    d(1, :, :) = [extSheepData(:,1) extWolfData(:,1) extGrassData(:,1) ...
        extAvgSheepEnergyData(:,1) extAvgWolfEnergyData(:,1) extAvgGrassCountdownData(:,1)];
    d(2, :, :) = [extSheepData(:,2) extWolfData(:,2) extGrassData(:,2) ...
        extAvgSheepEnergyData(:,2) extAvgWolfEnergyData(:,2) extAvgGrassCountdownData(:,2)];

    % Iterations axis
    x=1:iters;

    % Plot graphs
    figure(pop_fig);
    fill_between(x, extSheepData(:,1), extSheepData(:,2), 1, 'FaceColor', 'b');
    fill_between(x, extWolfData(:,1), extWolfData(:,2), 1, 'FaceColor', 'r');
    fill_between(x, extGrassData(:,1)./4, extGrassData(:,2)./4, 1, 'FaceColor', 'g');

    figure(en_fig);
    fill_between(x, extAvgSheepEnergyData(:,1), extAvgSheepEnergyData(:,2), 1, 'FaceColor', 'b');
    fill_between(x, extAvgWolfEnergyData(:,1), extAvgWolfEnergyData(:,2), 1, 'FaceColor', 'r');
    fill_between(x, 4*extAvgGrassCountdownData(:,1), 4*extAvgGrassCountdownData(:,2), 1, 'FaceColor', 'g');
    
elseif isnumeric(type) && type >= 0 % Moving average

    % Window size
    w = type;
    
    % Find averages
    avgSheepData = mean(sheepData, 2);
    avgWolfData = mean(wolfData, 2);
    avgGrassData = mean(grassData, 2);
    avgAvgSheepEnergyData = mean(avgSheepEnergyData, 2);
    avgAvgWolfEnergyData = mean(avgWolfEnergyData, 2);
    avgAvgGrassCountdownData = mean(avgGrassCountdownData, 2);
    
    % Smooth average?
    if w > 0
        avgSheepData = ma(avgSheepData, w);
        avgWolfData = ma(avgWolfData, w);
        avgGrassData = ma(avgGrassData, w);
        avgAvgSheepEnergyData = ma(avgAvgSheepEnergyData, w);
        avgAvgWolfEnergyData = ma(avgAvgWolfEnergyData, w);
        avgAvgGrassCountdownData = ma(avgAvgGrassCountdownData, w);
    end;
    
    % Initialize output matrix
    d = zeros(1, numel(avgSheepData), 6);

    % Fill output data
    d(1, :, :) = [avgSheepData avgWolfData avgGrassData ...
        avgAvgSheepEnergyData avgAvgWolfEnergyData avgAvgGrassCountdownData];
    
    % Plot averages
    figure(pop_fig);
    plot(avgSheepData, 'b');
    plot(avgWolfData, 'r');
    plot(avgGrassData ./ 4, 'g');

    figure(en_fig);
    plot(avgAvgSheepEnergyData, 'b');
    plot(avgAvgWolfEnergyData, 'r');
    plot(avgAvgGrassCountdownData * 4, 'g');
    
else
    
    error('Unknown type');

end;

% Set legends and title
figure(pop_fig);
h = legend('$P^s_i$', '$P^w_i$', '$P^c_i/4$');
set(h,'interpreter','Latex','FontSize',14);
title('Population');
xlabel('Iterations');
ylabel('Total population');

figure(en_fig);
h = legend('$\bar{E}^s_i$', '$\bar{E}^w_i$', '$4 \bar{C}_i$');
set(h,'interpreter','Latex','FontSize',14);
title('Energy');
xlabel('Iterations');
ylabel('Average energy');

% This function performs a moving average
function y = ma(x, w)

y = zeros(numel(x) - w, 1);
for i = 1:numel(y)
    if i <= w
        y(i) = sum(x((i - (i - 1)):(i + (i - 1)))) / (2 * i - 1);
    else
        y(i) = sum(x((i - w):(i + w))) / (2 * w + 1);
    end;
end;
