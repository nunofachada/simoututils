function [d, h] = output_plot(folder, files, outputs, varargin)
% OUTPUT_PLOT Plot time-series simulation output from one or more 
% replications using one of three approaches: superimposed, extremes or
% moving average.
%
%   [d, h] = OUTPUT_PLOT(folder, files, outputs, varargin)
%
% Parameters:
%   folder - Folder containing simulation output files.
%    files - Simulation output files (use wildcards for more than one
%            file).
%  outputs - Either an integer representing the number of outputs in 
%            each file or a cell array of strings with the output names.
%            In the former case, output names will be 'o1', 'o2', etc.
% varargin - Optional parameters as key-value pairs:
%          'type' - Type of plot:
%                   'a' - Superimposed outputs (default).
%                   'f' - Plot filled area encompassed by output extremes.
%                    w  - Moving average plot, w is an integer representing
%                        window size.
%        'layout' - Vector of integers specifying how many outputs to plot
%                   in each figure. Number of elements in vector will
%                   correspond to the number of figures, while the value of
%                   each element in vector will correspond to the number of
%                   outputs plotted in each figure. By default all outputs
%                   are plotted in the same figure.
%         'scale' - Values in this vector are element-wise multiplied by
%                   the corresponding outputs, and are used to scale
%                   outputs. If only one element is given, all outputs are
%                   multiplied by this element. Default is 1.
%         'iters' - Number of iterations to plot (default is 0, i.e., plot
%                   all iterations).
%        'Colors' - Each of these options is a cell array specifying
%    'LineStyles'   LineSpecs with which to plot individual outputs. If
%    'LineWidths'   there are more outputs than specs in the cell array,
%       'Markers'   the given specs are repeated. For 'f' type plots, these 
%'MarkerEdgeColors' options are interpreted as PatchSpecs, with 'Colors'
%'MarkerFaceColors' corresponding to 'FaceColors'. 'EdgeColors' is only
%   'MarkerSizes'   used in PatchSpecs. See help for LineSpec and 
%    'EdgeColors'   PatchSpec for more information on the available
%                   options.
%
% Outputs:
%    d - Matrix containing what was plotted. First dimension corresponds to
%        the number of outputs, second dimension to the number of 
%        iterations. If plot is of type == 'a', third dimension corresponds
%        to number of files (i.e. replications). If plot is of type == 'f', 
%        third dimension is 2 (for minima and maxima at each iteration, 
%        respectively). If plot is of type moving average, d only has two
%        dimensions.
%    h - Handles of created figures.
%
%
% Copyright (c) 2016 Nuno Fachada
% Distributed under the MIT License (See accompanying file LICENSE or copy 
% at http://opensource.org/licenses/MIT)
%

% Read files containing outputs
listing = dirnd([folder '/' files]);
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

% ARGS HERE
[type, layout, scale, iters, lineprops, patchprops] = ...
    parse_args(num_outputs, varargin);

% If iterations were not specified, use all available iterations
if iters == 0
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

% Number of figures to create
num_figures = numel(layout);

% Handles of created figures
h = zeros(1, num_figures);

% Create figures
for cfig = 1:num_figures
    h(cfig) = figure();
    hold on;
    grid on;    
end;

% How to plot outputs?

if type == 'a' % All, superimposed
    
    % In this case, the output matrix will be all_data
    d = all_data;
    
    % Cycle through the requested figures
    i1 = 1; % First output to plot in next figure
    for cfig = 1:num_figures
        
        % How many outputs to plot in current figure
        l = layout(cfig);
        
        % Last output to plot in next figure
        i2 = i1 + l - 1;
        
        % Select current figure
        figure(h(cfig));
        
        % Cycle through replications
        for f = 1:num_files
            
            % Cycle through outputs to plot in current figure
            for i = i1:i2
                
                % Get line properties for current output
                lp = struct2cell(lineprops(i));
                
                % Plot current output
                plot(all_data(i, 1:iters, f) * scale(i), lp{:});
    
            end;
            
        end;
        
        % Legend and axis labels
        xlim([0 iters]);
        legend(outputs(i1:i2));
        xlabel('Iterations');
        ylabel('Value');
        
        % First output to plot in next figure
        i1 = i2 + 1;
        
    end;
    
elseif type == 'f' % Filled
    
    % Initialize output matrix
    d = zeros(num_outputs, iters, 2);

    % Find extremes
    for i = 1:num_outputs
        d(i, :, 1) = min(all_data(i, :, :), [], 3);
        d(i, :, 2) = max(all_data(i, :, :), [], 3);
    end;
    
    % Cycle through the requested figures (number of figures corresponds to
    % the number of elements in variable "layout").
    i1 = 1; % First output to plot in next figure
    x = 1:iters; % Vector containing iterations to plot
    for cfig = 1:num_figures
        
        % How many outputs to plot in current figure
        l = layout(cfig);
        
        % Last output to plot in next figure
        i2 = i1 + l - 1;
        
        % Select current figure
        figure(h(cfig));
        
        % Cycle through outputs to plot in current figure
        for i = i1:i2

            % Get patch properties for current output
            pp = struct2cell(patchprops(i));
                
            % Plot extremes for current output
            fill_between(x, squeeze(d(i, :, 1)) * scale(i), ...
                squeeze(d(i, :, 2)) * scale(i), 1, pp{:});
    
        end;
        
        % Legend and axis labels
        xlim([0 iters]);
        legend(outputs(i1:i2));
        xlabel('Iterations');
        ylabel('Value');
        
        % First output to plot in next figure
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
    
    % Cycle through the requested figures (number of figures corresponds to
    % the number of elements in variable "layout").
    i1 = 1; % First output to plot in next figure
    for cfig = 1:num_figures
        
        % How many outputs to plot in current figure
        l = layout(cfig);
        
        % Last output to plot in next figure
        i2 = i1 + l - 1;
        
        % Select current figure
        figure(h(cfig));
        
        % Cycle through outputs to plot in current figure
        for i = i1:i2
            
            % Get line properties for current output
            lp = struct2cell(lineprops(i));

            % Plot moving average for current output
            plot(d(i, :) * scale(i), lp{:});
    
        end;
        
        % Legend and axis labels
        xlim([0 iters]);
        legend(outputs(i1:i2));
        xlabel('Iterations');
        ylabel('Value');
        
        % First output to plot in next figure
        i1 = i2 + 1;
        
    end;
    
   
else % Unknown type
    
    error('Unknown type');
    
end;


% % % % % % % % % % % % % % % % % % % % % % % %
% Helper function to parse optional arguments %
% % % % % % % % % % % % % % % % % % % % % % % %
function [type, layout, scale, iters, lineprops, patchprops] = ...
    parse_args(num_outputs, args)

% Some default values
type = 'a';
layout = num_outputs;
scale = ones(1, num_outputs);
iters = 0;
Colors = adjust_spec({'b', 'r', 'g', 'c', 'm', 'y', 'k'}, num_outputs);

% Line and patch properties, initially only set default colors
pidxs = 1:num_outputs;
lineprops = struct();
patchprops = struct();
[lineprops(pidxs).Colors_tag] = deal('Color');
[lineprops(pidxs).Colors] = deal(Colors{:});
[patchprops(pidxs).FaceColors_tag] = deal('FaceColor');
[patchprops(pidxs).FaceColors] = deal(Colors{:});

% Check if any arguments are given
numArgs = size(args, 2);
if numArgs > 0
    
    % arguments must come in pairs
    if mod(numArgs, 2) == 0
        
        % Parse arguments
        for i = 1:2:(numArgs - 1)
            
            if strcmp(args{i}, 'type')
                
                % Type of plot
                type = args{i + 1};
                
            elseif strcmp(args{i}, 'layout')
                
                % Layout
                layout = args{i + 1};
                
            elseif strcmp(args{i}, 'scale')
                
                % Scale
                scale = args{i + 1};

            elseif strcmp(args{i}, 'iters')
                
                % Iterations
                iters = args{i + 1};
                
            elseif strcmp(args{i}, 'Colors')
                
                % Colors
                Colors = adjust_spec(args{i + 1}, num_outputs);
                [lineprops(pidxs).Colors_tag] = deal('Color');
                [lineprops(pidxs).Colors] = deal(Colors{:});
                [patchprops(pidxs).FaceColors_tag] = deal('FaceColor');
                [patchprops(pidxs).FaceColors] = deal(Colors{:});

            elseif strcmp(args{i}, 'LineStyles')

                % LineStyles
                LineStyles = adjust_spec(args{i + 1}, num_outputs);
                [lineprops(pidxs).LineStyles_tag] = deal('LineStyle');
                [lineprops(pidxs).LineStyles] = deal(LineStyles{:});
                [patchprops(pidxs).LineStyles_tag] = deal('LineStyle');
                [patchprops(pidxs).LineStyles] = deal(LineStyles{:});

            elseif strcmp(args{i}, 'LineWidths')

                % LineWidths
                LineWidths = adjust_spec(args{i + 1}, num_outputs);
                [lineprops(pidxs).LineWidths_tag] = deal('LineWidth');
                [lineprops(pidxs).LineWidths] = deal(LineWidths{:});
                [patchprops(pidxs).LineWidths_tag] = deal('LineWidth');
                [patchprops(pidxs).LineWidths] = deal(LineWidths{:});
                
            elseif strcmp(args{i}, 'Markers')
                
                % Markers
                Markers = adjust_spec(args{i + 1}, num_outputs);
                [lineprops(pidxs).Markers_tag] = deal('Marker');
                [lineprops(pidxs).Markers] = deal(Markers{:});
                [patchprops(pidxs).Markers_tag] = deal('Marker');
                [patchprops(pidxs).Markers] = deal(Markers{:});
                
            elseif strcmp(args{i}, 'MarkerEdgeColors')
                
                % MarkerEdgeColors
                MarkerEdgeColors = adjust_spec(args{i + 1}, num_outputs);
                [lineprops(pidxs).MarkerEdgeColors_tag] = ...
                    deal('MarkerEdgeColor');
                [lineprops(pidxs).MarkerEdgeColors] = ...
                    deal(MarkerEdgeColors{:});
                [patchprops(pidxs).MarkerEdgeColors_tag] = ...
                    deal('MarkerEdgeColor');
                [patchprops(pidxs).MarkerEdgeColors] = ...
                    deal(MarkerEdgeColors{:});                
                
            elseif strcmp(args{i}, 'MarkerFaceColors')

                % MarkerFaceColors
                MarkerFaceColors = adjust_spec(args{i + 1}, num_outputs);
                [lineprops(pidxs).MarkerFaceColors_tag] = ...
                    deal('MarkerFaceColor');
                [lineprops(pidxs).MarkerFaceColors] = ...
                    deal(MarkerFaceColors{:});
                [patchprops(pidxs).MarkerFaceColors_tag] = ...
                    deal('MarkerFaceColor');
                [patchprops(pidxs).MarkerFaceColors] = ...
                    deal(MarkerFaceColors{:});                

            elseif strcmp(args{i}, 'MarkerSizes')
                
                % MarkerSizes
                MarkerSizes = adjust_spec(args{i + 1}, num_outputs);
                [lineprops(pidxs).MarkerSizes_tag] = deal('MarkerSize');
                [lineprops(pidxs).MarkerSizes] = deal(MarkerSizes{:});
                [patchprops(pidxs).MarkerSizes_tag] = deal('MarkerSize');
                [patchprops(pidxs).MarkerSizes] = deal(MarkerSizes{:});
                
            elseif strcmp(args{i}, 'EdgeColors')

                % EdgeColors, patch properties only
                EdgeColors = adjust_spec(args{i + 1}, num_outputs);
                [patchprops(pidxs).EdgeColors_tag] = deal('EdgeColor');
                [patchprops(pidxs).EdgeColors] = deal(EdgeColors{:});
                
            else
                
                % Oops... unknown parameter
                error('Unknown parameter "%s"', args{i});
                
            end;
        end;
    else
        
        % arguments must come in pairs
        error('Incorrect number of optional arguments.');
        
    end;
end;

% Adjust scale to number of outputs
if numel(scale) == 1
    scale = scale * ones(1, num_outputs);
end;

% % % % % % % % % % % % % % % % % % % % % % % % 
% Helper function to adjust line specs and patch specs
% to match the number of outputs to plot
% % % % % % % % % % % % % % % % % % % % % % % %
function spec = adjust_spec(spec, num_outputs)

% If spec is not in cell format, put it in cell format
if ~iscell(spec)
    spec = {spec};
end;

% Do we need to expand the spec to have number of elements equal to number
% of outputs?
if numel(spec) < num_outputs
    
    % Repeatly concatenate given spec until there are more elements than
    % outputs 
    while numel(spec) < num_outputs
        spec = {spec{:}, spec{:}};
    end;
    
end;

% Make sure there are no more specs than outputs
spec = spec(1:num_outputs);
