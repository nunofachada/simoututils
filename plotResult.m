function plotResult(file, sheepCol, sheepScale, wolfCol, wolfScale, grassCol, grassScale)

% Read stats file
data = dlmread(file);
sheepData = data(:, sheepCol);
wolfData = data(:, wolfCol);
grassData = data(:, grassCol);

% Plot figure
figure;
hold on;
grid on;
plot(sheepData * sheepScale, 'b');
plot(wolfData * wolfScale, 'r');
plot(grassData * grassScale, 'g');
legend('Sheep', 'Wolf', 'Grass');

