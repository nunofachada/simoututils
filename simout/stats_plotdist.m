function hout = stats_plotdist(datas, output, stat, outname)
% STATS_PLOTDIST Plot the distributional properties of one focal measure 
% (i.e. of a statistical summary of a single output), namely its 
% probability density function (estimated), histogram and QQ-plot.
%
%   hout = STATS_PLOTDIST(datas, output, stat, outname)
%
% Parameters:
%   datas - Cell array with stats to analyze, each cell correspond to stats
%          returned by the stats_gather function for a model configuration.
%  output - Index of output to analyze (1, 2, ...).
%    stat - Index of statistical summary to analyze (1 to 6).
% outname - Output name (optional), used for the figure title.
%
% Returns:
%    hout - Figure handle.
%
% Description:
%     For each model configuration, three vertically stacked subplots are 
%     shown: 1) estimated probability density function; 2) histogram; and,
%     3) QQ-plot. The first plot also shows the mean (vertical dashed red
%     line), the t and Willink confidence intervals (in lighter and darker
%     greys, respectively), and a text box with the mean, variance, 
%     skewness and p-value of the Shapiro-Wilk test.
%
% See also STATS_GATHER.
%
% Copyright (c) 2015 Nuno Fachada
% Distributed under the MIT License (See accompanying file LICENSE or copy 
% at http://opensource.org/licenses/MIT)
%

% Output name
if nargin == 3
    outname = 'Output';
end;

% Statistical summaries
stsumm = {'max','argmax','min','argmin','mean','std'};

% Figure containing all subplots
hout = figure();

% What is the exact index of the focal measure being analyzed?
idx = (output - 1) * 6 + stat;

% Cycle through all data sets
for i=1:numel(datas)

    % Analyze current data set
    [m, v, cit, ciw, sw, s] = stats_analyze(datas{i}.sdata(:, idx), 0.01);
    
    % Create subplot 1 (estimated PDF)
    h = subplot(3, numel(datas), i);

    if (v > 0)
        [~, f, xi] = kde(datas{i}.sdata(:, idx));
    else
        xi = [m m];
        f = ylim(h);
    end;
    plot(xi, f);
    hold on;
    yl = ylim(h);
    if v > 0
        fill([ciw(1) ciw(1) ciw(2) ciw(2)], [yl(1) yl(2) yl(2) yl(1)], ...
            [.6 .6 .6], 'EdgeColor','none');
        fill([cit(1) cit(1) cit(2) cit(2)], [yl(1) yl(2) yl(2) yl(1)], ...
            [.8 .8 .8], 'EdgeColor','none');
        plot(xi, f);
    end;
    plot([m m], ylim(h), 'r--');
    print_text(h, datas{i}.name, m, v, sw, s);
    title('PDF + Info');
    
    % Create subplot 2 (histogram)
    subplot(3, numel(datas), numel(datas) + i);
    hist(datas{i}.sdata(:, idx), ...
        min(10, numel(unique(datas{i}.sdata(:, idx)))));
    title('Histogram');
    
    % Create subplot 3 (QQ-plot)
    subplot(3, numel(datas), numel(datas) * 2 + i);
    qqplot(datas{i}.sdata(:, idx));
    
end;

% Set global figure title
figtitle([stsumm{stat} ' ( ' outname ' )']);

% Helper function to print info text in subplot 1
function print_text(h, name, m, v, d, s)

xl = xlim(h); 
xPos = xl(1) + diff(xl) / 2; 
yl = ylim(h); 
yPos = yl(1) + diff(yl) / 2;
txt = sprintf('%s\nmu = %8.4g\nvar = %8.4g\nskew = %8.4g\nSW-test = %6.4f', ...
    name, m, v, s, d);
t=text(xPos, yPos, txt, 'Parent', h);
set(t, 'HorizontalAlignment', 'center');

