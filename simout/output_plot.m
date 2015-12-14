function output_plot(file, outputs, layout, scale, colors)
% OUTPUT_PLOT Plot time-series simulation output.
%
%   OUTPUT_PLOT(file, outputs, layout, scale, colors)
%
% Parameters:
%        file - file containing output of one simulation run.
%     outputs - Either an integer representing the number of outputs in 
%               each file or a cell array of strings with the output names.
%               In the former case, output names will be 'o1', 'o2', etc.
%      layout -
%       scale -
%      colors -
%
% Copyright (c) 2015 Nuno Fachada
% Distributed under the MIT License (See accompanying file LICENSE or copy 
% at http://opensource.org/licenses/MIT)
%

% Read file containing outputs
data = dlmread(file);

% Default output names if respective arguments not given
if nargin < 2
    num_outputs = size(data, 2);
    outputs = parse_output_names(num_outputs);
else
    [outputs, num_outputs] = parse_output_names(outputs);
end;

% Default layout
if nargin < 3
    layout = num_outputs;
end;

% Default scale
if nargin < 4
    scale = ones(1, num_outputs);
elseif numel(scale) == 1
    scale = scale * ones(1, num_outputs);
end;

% Default colors
if nargin < 5, colors = {'b', 'r', 'g', 'c', 'm', 'y', 'k'}; end;

% Start plotting outputs
i1 = 1;
for l = layout
    
    i2 = i1 + l - 1;
    
    figure();
    hold on;
    grid on;
    
    for i = i1:i2
        plot(data(:, i) * scale(i), colors{i - i1 + 1});
    end;

    xlim([0 size(data, 1)]);
    h = legend(outputs(i1:i2));
    %set(h,'interpreter','Latex','FontSize',14);
    xlabel('Iterations');
    ylabel('Value');
    
    i1 = i2 + 1;
    
end;



