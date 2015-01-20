function [extremes, averages, stds, signchange] = getStats(file)

% Read stats file
data = dlmread(file);
sheepData = data(:, 1);
wolfData = data(:, 2);
grassData = data(:, 3);

% Get extremes
maxSheep = max(sheepData);
maxSheepIter = find(sheepData == maxSheep, 1) - 1;
minWolf = min(wolfData);
minWolfIter = find(wolfData == minWolf, 1) - 1;
minGrass = min(grassData);
minGrassIter = find(grassData == minGrass, 1) - 1;

extremes = [maxSheep maxSheepIter minWolf minWolfIter minGrass minGrassIter];

% Get averages
avgSheep = mean(sheepData(1001:4001));
avgWolf = mean(wolfData(1001:4001));
avgGrass = mean(grassData(1001:4001));

averages = [avgSheep avgWolf avgGrass];

% Get standard deviations
stdSheep = std(sheepData(1001:4001));
stdWolf = std(wolfData(1001:4001));
stdGrass = std(grassData(1001:4001));

stds = [stdSheep stdWolf stdGrass];

% Get sheep vs. grass/4 sign changes
vect = sheepData - grassData / 4;
signchange = find([0 diff(sign(vect'))]~=0);


