function table_info = dist_table_per_fm(datas, output, stat, pre)
% DIST_TABLE_PER_FM Outputs a LaTeX table with a distributional
% analysis of a PPHPC focal measure for a number of setups/configurations.
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
%     
%
% Copyright (c) 2015 Nuno Fachada
% Distributed under the MIT License (See accompanying file LICENSE or copy 
% at http://opensource.org/licenses/MIT)
%

% Example:
% datas = {st30_nl100v1, st30_nl200v1, st30_nl400v1, st30_nl800v1, st30_nl1600v1, st30_nl100v2, st30_nl200v2, st30_nl400v2, st30_nl800v2, st30_nl1600v2};
% pp_stats_latextable_fm(datas, 1, 3);

% if "pre" parameter not specified, set default value to 0
if nargin < 4
    pre = 0;
end;

% Set pre-columns before data
pretxt = ' ';
for i=1:pre
    pretxt = sprinf('& %s', pretxt);
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
        histc(datas{i}.sdata(:, idx), edges(datas{i}.sdata(:, idx)));
        
    % Create data for qq plot, keep data
    table_info{4, i} = qqcalc(datas{i}.sdata(:, idx));
    
end;

% Print data name as comment
fprintf('%% ');
for i=1:numel(datas)
    fprintf(' %s | ', datas{i}.name);
end;
fprintf('\n');

% Print SW p-values
fprintf('%sSW ', pretxt);
for i=1:numel(datas)
    fprintf('& %s ', ltxp(table_info{1, i}));
end;
fprintf('\\\\ \n');

% Print Skewness
fprintf('%sSkew. ', pretxt);
for i=1:numel(datas)
    fprintf('& %s ', ltx(table_info{2, i}));
end;
fprintf('\\\\ \n');

% Print histograms
fprintf('%sHist. ', pretxt);
for i=1:numel(datas)
    fprintf('& %s ', tikhist(table_info{3, i}));
end;
fprintf('\\\\ \n');

% Print QQ-plots
fprintf('%sQ-Q ', pretxt);
for i=1:numel(datas)
    fprintf('& %s ', tikqq(table_info{4, i}));
end;
fprintf('\\\\ \n');
