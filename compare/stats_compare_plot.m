function h = stats_compare_plot(varargin)
% STATS_COMPARE_PLOT Plot the probability density function (PDF) and 
% cumulative distribution function (CDF) of focal measures from a number of
% model implementations.
%
%   h = STATS_COMPARE_PLOT(varargin)
%
% Parameters:
%   varargin - Samples of focal measures obtained with the stats_gather
%   function.
%
% Returns:
%    h - Struct array of figure handles, with three fields: 
%        fig - Handles for top level figures.
%        pdf - Handles for PDF subplots.
%        cdf - Handles for CDF subplots.
%
% Copyright (c) 2015 Nuno Fachada
% Distributed under the MIT License (See accompanying file LICENSE or copy 
% at http://opensource.org/licenses/MIT)
%

% Default plot lines
markers = [{'b'} {'r'} {'g'} {'c'} {'m'} {'k'} ...
    {'--r'} {'--g'} {'--b'} {'--c'} {'--m'} {'--k'} ...
    {'.r'} {'.g'} {'.b'} {'.c'} {'.m'} {'.k'}];

% Get output names
outputs = varargin{1}.outputs;

% Get names of statistical summaries
ssumms_struct = varargin{1}.ssnames;
ssumms = ssumms_struct.text;

% Get handles for figures and subplots
h = get_plot_handles(outputs, ssumms);

% Create cell array of strings for legends
legends = cell(nargin - 1, 1);

% Determine legends and draw plots
for i = 1:nargin
    legends{i} = varargin{i}.name;
    do_plot(varargin{i}, h, markers{i}, outputs, ssumms);
end;

% Add legends to plots
for i = 1:numel(h)
    figure(h(i).fig);
    legend(legends);
end;


% %%%%%%%%%
% Helper function which actually draws each plot
% %%%%%%%%%
function do_plot(stats, handles, lspec, outputs, ssumms)

% One figure per output
for i = 1:numel(outputs)
    
    % Focus current figure
    figure(handles(i).fig);
    
    % Cycle through statistical summaries
    for j = 1:numel(ssumms)

        % What is the exact index of the focal measure being analyzed?
        idx = (i - 1) * numel(outputs) + j;

        % Determine PDF estimate
        if var(stats.sdata(:, idx)) > 0
            
            % Get kernel density
            [~, f, xi] = kde(stats.sdata(:, idx), 2^4);
            
        else
            
            % No point in drawing PDF if variance is zero, just draw a
            % vertical line with the mean
            xi = repmat(mean(stats.sdata(:, idx)), 1, 2);
            f = [-1 1];
            
        end;
        
        % Plot PDF
        subplot(handles(i).pdf(j));
        plot(xi, f, lspec);
       
        % Calculate CDF
        [f, x] = homemade_ecdf(stats.sdata(:, idx));

        % Plot CDF
        subplot(handles(i).cdf(j));
        plot(x, f, lspec);
        
    end;
    
end;

% %%%%%%%%%
% Helper function which gets plot handles
% %%%%%%%%%
function handles = get_plot_handles(outputs, ssumms)

% Struct array of handles
handles = struct('fig', {}, 'pdf', {}, 'cdf', {});

% Cycle through outputs
for i = 1:numel(outputs)
    
    % Create figure for current output
    h = figure();
    
    % Initialize vectors of handles for PDF and CDF subplots
    h_pdf = zeros(numel(ssumms, 1));
    h_cdf = zeros(numel(ssumms, 1));
    
    % Cycle through statistical summaries
    for j = 1:numel(ssumms)

        % PDF
        h_pdf(j) = subplot(2, numel(ssumms), j);
        title([ssumms{j} ' - PDF']);
        hold on; grid on;
       
        % CDF
        h_cdf(j) = subplot(2, numel(ssumms), numel(ssumms) + j);
        title([ssumms{j} ' - CDF']);
        hold on; grid on;
        
    end;
    
    % Keep handles
    handles(i).fig = h;
    handles(i).pdf = h_pdf; 
    handles(i).cdf = h_cdf;
    
    % Add title (the output name) to current figure
    figtitle(outputs{i});
    
end;

