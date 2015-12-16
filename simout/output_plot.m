function d = output_plot(...
    folder, files, outputs, type, layout, scale, colors, iters)
% OUTPUT_PLOT Plot time-series simulation output.
%
%   OUTPUT_PLOT(folder, file, outputs, type, layout, scale, colors, iters)
%
% Parameters:
%      folder - Folder containing simulation output files.
%       files - Simulation output files (use wildcards for more than one
%               file).
%     outputs - Either an integer representing the number of outputs in 
%               each file or a cell array of strings with the output names.
%               In the former case, output names will be 'o1', 'o2', etc.
%        type - Type of plot:
%               'a' - Superimposed outputs (default).
%               'f' - Plot filled area encompassed by output extremes.
%               0...w - Moving average, window size w
%      layout -
%       scale -
%      colors -
%
% Outputs:
%    d - Tri-dimensional matrix containing what was plotted. First 
%        dimension corresponding to number of outputs, second dimension to
%        number of iterations, and third dimension depends on the type of
%        plot. If plot is of type == 'a', third dimensions corresponds to
%        number of files, else if plot is of type == 'f', third dimension
%        is 2 (for minima and maxima, respectively), else if plot is of
%        type moving average, third dimension is 1 (the averaged output).
%
%
% Copyright (c) 2015 Nuno Fachada
% Distributed under the MIT License (See accompanying file LICENSE or copy 
% at http://opensource.org/licenses/MIT)
%

% Read files containing outputs
listing = dir([folder '/' files]);
num_files = size(listing, 1);

% Were any files found?
if num_files == 0
    error('No files found.');
end;

% Load data from first file (used for defaults)
data = dlmread([folder '/' listing(1).name]);

% Default output names if respective arguments not given
if nargin < 3
    num_outputs = size(data, 2);
    outputs = parse_output_names(num_outputs);
else
    [outputs, num_outputs] = parse_output_names(outputs);
end;

% Default type
if nargin < 4
    type = 'a';
end;

% Default layout
if nargin < 5
    layout = num_outputs;
end;

% Default scale
if nargin < 6
    scale = ones(1, num_outputs);
elseif numel(scale) == 1
    scale = scale * ones(1, num_outputs);
end;

% Default colors
if nargin < 7
    colors = {'b', 'r', 'g', 'c', 'm', 'y', 'k'}; 
end;

% Default number of iterations
if nargin < 8
    iters = size(data, 1);
end;

% Initialize data vector
all_data = zeros(num_outputs, iters, num_files);

% Load data from files
for i = 1:num_files
            
    data = dlmread([folder '/' listing(i).name]);
    for j = 1:num_outputs
        all_data(j, :, i) = data(1:iters, j);
    end;
    
end;

if type == 'a' % All, superimposed
    
    % In this case, the output matrix will be all_data
    d = all_data;
    
    % Start plotting outputs
    i1 = 1;
    for l = layout
        
        i2 = i1 + l - 1;
        
        figure();
        hold on;
        grid on;
        
        for f = 1:num_files
            
            for i = i1:i2
                
                plot(all_data(i, 1:iters, f) * scale(i), ...
                    colors{i - i1 + 1});
    
            end;
            
        end;
        
        xlim([0 size(data, 1)]);
        h = legend(outputs(i1:i2));
        %set(h,'interpreter','Latex','FontSize',14);
        xlabel('Iterations');
        ylabel('Value');
        
        i1 = i2 + 1;
        
    end;
    
elseif type == 'f' % Filled
    
    % There are problems with the legends in octave
    if is_octave()
        warning('Legends may not appear correctly in Octave');
    end;
    
    % Initialize output matrix
    d = zeros(num_outputs, iters, 2);

    % Find extremes
    for i = 1:num_outputs
        d(i, :, 1) = min(all_data(i, :, :), [], 3);
        d(i, :, 2) = max(all_data(i, :, :), [], 3);
    end;
    
    % Plot graphs
    i1 = 1;
    x = 1:iters;
    for l = layout
        
        i2 = i1 + l - 1;
        
        figure();
        hold on;
        grid on;
        
        for i = i1:i2
                
            fill_between(x, squeeze(d(i, :, 1)) * scale(i), ...
                squeeze(d(i, :, 2)) * scale(i), ...
                1, 'FaceColor', colors{i - i1 + 1});
    
        end;
        
        xlim([0 size(data, 1)]);
        h = legend(outputs(i1:i2));
        %set(h,'interpreter','Latex','FontSize',14);
        xlabel('Iterations');
        ylabel('Value');
        
        i1 = i2 + 1;
        
    end;
    
    
elseif isnumeric(type) && type >= 0 % Moving average
    
    % Window size
    w = type;
    
    % Initialize output matrix
    d = zeros(num_outputs, iters - w);
    
    % Find averages
    for i = 1:num_outputs
        
        d(i, :) = mavg(mean(all_data(i, :, :), 3), w);

    end;
    
    % Plot graphs
    i1 = 1;
    for l = layout
        
        i2 = i1 + l - 1;
        
        figure();
        hold on;
        grid on;
        
        for i = i1:i2
                
            plot(d(i, :) * scale(i), ...
                colors{i - i1 + 1});
    
        end;
        
        xlim([0 size(data, 1)]);
        h = legend(outputs(i1:i2));
        %set(h,'interpreter','Latex','FontSize',14);
        xlabel('Iterations');
        ylabel('Value');
        
        i1 = i2 + 1;
        
    end;
    
   
else % Unknown type
    
    error('Unknown type');
    
end;






