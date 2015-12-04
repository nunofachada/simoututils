function t = dist_table_per_fm(datas, output, stat, pre)
% DIST_TABLE_PER_FM Outputs a LaTeX table with a distributional
% analysis of a focal measure for a number of setups/configurations.
% For each setup/configuration, the table shows the p-value of the 
% Shapiro-Wilk test, skewness, histogram and QQ-plot.
%
%   t = DIST_TABLE_PER_FM(datas, output, stat, pre)
%
% Parameters:
%      datas - Cell array with stats to analyze, each cell containing stats 
%              returned by the stats_gather function for one model 
%              setup/configuration.
%     output - Index of output to analyze (1 to 6).
%       stat - Index of statistical summary to analyze (1 to 6).
%        pre - How many columns before data (optional, default is 0).
%
% Returns:
%      t - A string containing the LaTeX table.
% 
% Note:
%     This function returns a partial table, which can have additional
%     columns (specified with the 'pre' parameter) prior to the data, as
%     well as additional rows (headers, footers, similar partial tables for
%     other focal measures, etc).
%
% Copyright (c) 2015 Nuno Fachada
% Distributed under the MIT License (See accompanying file LICENSE or copy 
% at http://opensource.org/licenses/MIT)
%

% if "pre" parameter not specified, set default value to 0
if nargin < 4
    pre = 0;
end;

% Set pre-columns before data
pretxt = ' ';
for i=1:pre
    pretxt = sprintf('& %s', pretxt);
end;

% Table containing data to print in latex table: sw, skew, hist, qq
table_info = cell(4, numel(datas));

% What is the exact index of the focal measure being analyzed?
idx = (output - 1) * 6 + stat;

% Cycle through all setups/configurations
for i=1:numel(datas)

    % Analyze current data set, keep SW and Skewness
    [~, ~, ~, ~, table_info{1, i}, table_info{2, i}] = ...
        stats_analyze(datas{i}.sdata(:, idx), 0.01);
    
    % Create histogram, keep data
    table_info{3, i} = ...
        histc(datas{i}.sdata(:, idx), hist_edges(datas{i}.sdata(:, idx)));
        
    % Create data for qq plot, keep data
    table_info{4, i} = qqcalc(datas{i}.sdata(:, idx));
    
end;

% Print data name as comment
t = sprintf('%% ');
for i=1:numel(datas)
    t = sprintf('%s %s | ', t, datas{i}.name);
end;
t = sprintf('%s\n', t);

% Print SW p-values
t = sprintf('%s%sSW ', t, pretxt);
for i=1:numel(datas)
    t = sprintf('%s& %s ', t, ltxp(table_info{1, i}));
end;
t = sprintf('%s\\\\ \n', t);

% Print Skewness
t = sprintf('%s%sSkew. ', t, pretxt);
for i=1:numel(datas)
    t = sprintf('%s& %s ', t, ltxr(table_info{2, i}));
end;
t = sprintf('%s\\\\ \n', t);

% Print histograms
t = sprintf('%s%sHist. ', t, pretxt);
for i=1:numel(datas)
    t = sprintf('%s& \\multicolumn{1}{c}{\\resizebox {!} {0.5cm} {%s}} ', t, tikhist(table_info{3, i}));
end;
t = sprintf('%s\\\\ \n', t);

% Print QQ-plots
t = sprintf('%s%sQ-Q ', t, pretxt);
for i=1:numel(datas)
    t = sprintf('%s& \\raisebox{-.5\\height}{\\resizebox {1.2cm} {1.2cm} {%s}} ', t, tikqq(table_info{4, i}));
end;
t = sprintf('%s\\\\ \n', t);
