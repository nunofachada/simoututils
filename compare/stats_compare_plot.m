function stats_compare_plot(varargin)
% STATS_COMPARE_PLOT Plot statistical distributions of focal measures.
%
%   STATS_COMPARE_PLOT(varargin)
%
% Parameters:
%   varargin - P-value to format.
%
% Returns:
%
% Copyright (c) 2015 Nuno Fachada
% Distributed under the MIT License (See accompanying file LICENSE or copy 
% at http://opensource.org/licenses/MIT)
%

markers = [{'b'} {'r'} {'g'} {'c'} {'m'} {'k'} ...
    {'--r'} {'--g'} {'--b'} {'--c'} {'--m'} {'--k'} ...
    {'.r'} {'.g'} {'.b'} {'.c'} {'.m'} {'.k'}];

outputs = {'Sheep pop.', 'Wolf pop.', 'Grass qty.', 'Sheep en.', ...
    'Wolf en.', 'Grass en.'};
ssumms = {'max','argmax','min','argmin','mean','std'};

handles = get_plot_handles(outputs, ssumms);

legends = cell(nargin-1, 1);

for i=1:nargin
    legends{i} = varargin{i}.name;
    do_plot(varargin{i}, handles, markers{i}, outputs, ssumms);
end;

for i=1:numel(handles)
    figure(handles{i}.fig);
    legend(legends);
end;


% %%%%%%%%%
% Helper function which actually draws each plot
% %%%%%%%%%
function do_plot(stats, handles, lspec, outputs, ssumms)

for i=1:numel(outputs)
    
    figure(handles{i}.fig);
    
    for j=1:numel(ssumms)

        % What is the exact index of the focal measure being analyzed?
        idx = (i-1)*6 + j;

        % PDF
        [f, xi] = ksdensity(stats.sdata(:, idx));
        subplot(handles{i}.pdf(j));
        plot(xi, f, lspec);
       
        % CDF
        [f, x] = ecdf(stats.sdata(:, idx));
        subplot(handles{i}.cdf(j));
        plot(x, f, lspec);
        
    end;
    
end;

% %%%%%%%%%
% Helper function which gets plot handles
% %%%%%%%%%
function handles = get_plot_handles(outputs, ssumms)

handles = cell(numel(ssumms), 1);

for i=1:numel(outputs)
    
    h = figure;
    h_pdf = zeros(numel(ssumms, 1));
    h_cdf = zeros(numel(ssumms, 1));
    
    for j=1:numel(ssumms)

        % PDF
        h_pdf(j) = subplot(2, numel(ssumms), j);
        title([ssumms{j} ' - PDF']);
        hold on; grid on;
       
        % CDF
        h_cdf(j) = subplot(2, numel(ssumms), numel(ssumms) + j);
        title([ssumms{j} ' - CDF']);
        hold on; grid on;
        
    end;
    
    handles{i} = struct('fig', h, 'pdf', h_pdf, 'cdf', h_cdf);
    
    figtitle(outputs{i});
    
end;

