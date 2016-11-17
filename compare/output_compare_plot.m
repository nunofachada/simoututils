function [d, h] = ...
    output_compare_plot(impls, folders, files, outputs, varargin)
% OUTPUT_COMPARE_PLOT Plot time-series simulation output from one or more 
% replications of two or more model implementations using a moving average.
%
%   [d, h] = OUTPUT_COMPARE_PLOT(impls, folders, files, outputs, varargin)
%
% Parameters:
%    impls - Cell array of strings containing the names of the model
%            implementations.
%  folders - Cell array of strings specifying folders containing simulation
%            output files. Each folder corresponds to a model
%            implementation.
%    files - Cell array of strings specifying simulation output files (use
%            wildcards for more than one file). Each file string
%            corresponds to a folder
%  outputs - Either an integer representing the number of outputs in 
%            each file or a cell array of strings with the output names.
%            In the former case, output names will be 'o1', 'o2', etc.
% varargin - Optional parameters as key-value pairs:
%              'ws' - Window size for moving average. A value of 0 simply
%                     shows the mean plot per model implementation. Default
%                     is 0.
%           'iters' - Number of iterations to plot (default is 0, i.e.,
%                     plot all iterations).
%          'Colors' - Each of these options is a cell array specifying
%      'LineStyles'   LineSpecs with which to plot outputs for individual
%      'LineWidths'   model implementations. If there are more model
%         'Markers'   implementations than specs in the cell array, the
%'MarkerEdgeColors'   given specs are repeated. See help for LineSpec for
%'MarkerFaceColors'   more information on the available options.
%     'MarkerSizes'
%
% Outputs:
%    d - Matrix containing what was plotted. First dimension corresponds to
%        the model implementation, the second dimension to outputs, and
%        third dimension to the number of iterations. 
%    h - Handles of created figures.
%
%
% Copyright (c) 2016 Nuno Fachada
% Distributed under the MIT License (See accompanying file LICENSE or copy 
% at http://opensource.org/licenses/MIT)
%

% Determine number of outputs and output names
[outputs, num_outputs] = parse_output_names(outputs);

num_modimpls = numel(folders);

% Parse optional arguments
[ws, iters, lineprops] = parse_args(num_modimpls, varargin);

% Vector with handles to the created figures
h = zeros(1, num_outputs);

% Create figures, one per output
for i = 1:num_outputs
    h(i) = figure();
    hold on;
    grid on;     
end;

% Initialize output matrix
d = zeros(num_modimpls, num_outputs, iters - ws);

% Cycle through model implementations
for i = 1:num_modimpls
    
    % Read files containing outputs for current model implementation
    listing = dirnd([folders{i} '/' files{i}]);
    num_files = size(listing, 1);

    % Were any files found?
    if num_files == 0
        error(['No files found for model implementation ' num2str(i)]);
    end;    

%     % Load data from first file (used for defaults)
%     data = dlmread([folders{i} '/' listing(1).name]);
% 
%     % If iterations were not specified, use all available iterations
%     if iters == 0
%         iters = size(data, 1);
%     end;

    % Initialize data vector
    all_data = zeros(num_outputs, iters, num_files);

    % Load data from files
    for j = 1:num_files

        data = dlmread([folders{i} '/' listing(i).name]);
        for k = 1:num_outputs
            all_data(k, :, j) = data(1:iters, k);
        end;

    end;
    
    % Cycle through outputs
    for j = 1:num_outputs
        
        % Determine current averaged output
        d(i, j, :) = mavg(mean(all_data(j, :, :), 3), ws);
        
        % Select figure
        figure(h(j));

        % Get line properties for current output
        lp = struct2cell(lineprops(i));

        % Plot moving average for current output
        plot(reshape(d(i, j, :), [1 numel(d(i, j, :))]), lp{:});
        
    end;
    
end;
   
% Decorate figures
for i = 1:num_outputs
    
    % Select figure
    figure(h(i));

    % Legend and axis labels
    xlim([0 (iters - ws)]);
    legend(impls);
    xlabel('Iterations');
    ylabel('Value');
    title(outputs{i});
    
end;

% % % % % % % % % % % % % % % % % % % % % % % %
% Helper function to parse optional arguments %
% % % % % % % % % % % % % % % % % % % % % % % %
function [ws, iters, lineprops] = parse_args(num_modimpls, args)

% Some default values
ws = 0;
iters = 0;
Colors = adjust_spec({'b', 'r', 'g', 'c', 'm', 'y', 'k'}, num_modimpls);

% Line and patch properties, initially only set default colors
pidxs = 1:num_modimpls;
lineprops = struct();
[lineprops(pidxs).Colors_tag] = deal('Color');
[lineprops(pidxs).Colors] = deal(Colors{:});

% Check if any arguments are given
numArgs = size(args, 2);
if numArgs > 0
    
    % arguments must come in pairs
    if mod(numArgs, 2) == 0
        
        % Parse arguments
        for i = 1:2:(numArgs - 1)
            if strcmp(args{i}, 'ws')
                
                % Window size
                ws = args{i + 1};
                
            elseif strcmp(args{i}, 'iters')
                
                % Iterations
                iters = args{i + 1};
                
            elseif strcmp(args{i}, 'Colors')
                
                % Colors
                Colors = adjust_spec(args{i + 1}, num_outputs);
                [lineprops(pidxs).Colors_tag] = deal('Color');
                [lineprops(pidxs).Colors] = deal(Colors{:});

            elseif strcmp(args{i}, 'LineStyles')

                % LineStyles
                LineStyles = adjust_spec(args{i + 1}, num_outputs);
                [lineprops(pidxs).LineStyles_tag] = deal('LineStyle');
                [lineprops(pidxs).LineStyles] = deal(LineStyles{:});

            elseif strcmp(args{i}, 'LineWidths')

                % LineWidths
                LineWidths = adjust_spec(args{i + 1}, num_outputs);
                [lineprops(pidxs).LineWidths_tag] = deal('LineWidth');
                [lineprops(pidxs).LineWidths] = deal(LineWidths{:});
                
            elseif strcmp(args{i}, 'Markers')
                
                % Markers
                Markers = adjust_spec(args{i + 1}, num_outputs);
                [lineprops(pidxs).Markers_tag] = deal('Marker');
                [lineprops(pidxs).Markers] = deal(Markers{:});
                
            elseif strcmp(args{i}, 'MarkerEdgeColors')
                
                % MarkerEdgeColors
                MarkerEdgeColors = adjust_spec(args{i + 1}, num_outputs);
                [lineprops(pidxs).MarkerEdgeColors_tag] = ...
                    deal('MarkerEdgeColor');
                [lineprops(pidxs).MarkerEdgeColors] = ...
                    deal(MarkerEdgeColors{:});
                
            elseif strcmp(args{i}, 'MarkerFaceColors')

                % MarkerFaceColors
                MarkerFaceColors = adjust_spec(args{i + 1}, num_outputs);
                [lineprops(pidxs).MarkerFaceColors_tag] = ...
                    deal('MarkerFaceColor');
                [lineprops(pidxs).MarkerFaceColors] = ...
                    deal(MarkerFaceColors{:});

            elseif strcmp(args{i}, 'MarkerSizes')
                
                % MarkerSizes
                MarkerSizes = adjust_spec(args{i + 1}, num_outputs);
                [lineprops(pidxs).MarkerSizes_tag] = deal('MarkerSize');
                [lineprops(pidxs).MarkerSizes] = deal(MarkerSizes{:});
                
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


% % % % % % % % % % % % % % % % % % % % % % % % 
% Helper function to adjust line specs and patch specs
% to match the number of model implementations
% % % % % % % % % % % % % % % % % % % % % % % %
function spec = adjust_spec(spec, num_modimples)

% If spec is not in cell format, put it in cell format
if ~iscell(spec)
    spec = {spec};
end;

% Do we need to expand the spec to have number of elements equal to number
% of model implementations?
if numel(spec) < num_modimples
    
    % Repeatly concatenate given spec until there are more elements than
    % model implementations
    while numel(spec) < num_modimples
        spec = {spec{:}, spec{:}};
    end;
    
end;

% Make sure there are no more specs than model implementations
spec = spec(1:num_modimples);
