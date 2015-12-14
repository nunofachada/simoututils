function output_plot(...
    folder, file, outputs, type, layout, scale, colors, iters)
% OUTPUT_PLOT Plot time-series simulation output.
%
%   OUTPUT_PLOT(folder, file, outputs, type, layout, scale, colors, iters)
%
% Parameters:
%        file - file containing output of one simulation run.
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

% Start plotting outputs
i1 = 1;
for l = layout
    
    i2 = i1 + l - 1;
    
    figure();
    hold on;
    grid on;
    
    for i = i1:i2
        
        for j = 1:numFiles
            
            data = dlmread([folder '/' listing(j).name]);
            plot(data(:, i) * scale(i), colors{i - i1 + 1});
            
        end;    
    end;

    xlim([0 size(data, 1)]);
    h = legend(outputs(i1:i2));
    %set(h,'interpreter','Latex','FontSize',14);
    xlabel('Iterations');
    ylabel('Value');
    
    i1 = i2 + 1;
    
end;



