function t = dist_table_per_setup(data)
% DIST_TABLE_PER_SETUP Outputs a LaTeX table with a distributional
% analysis of all focal measures for one model setup/configuration. For 
% each focal measure, the table shows the mean, variance, p-value of the 
% Shapiro-Wilk test, skewness, histogram and QQ-plot. Requires the siunitx, 
% multirow and booktabs LaTeX packages.
%
%   t = DIST_TABLE_PER_SETUP(data)
%
% Parameters:
%      data - Stats returned by the stats_gather function for a number of 
%             runs with the desired model setup/configuration.
%
% Returns:
%      t - A string containing the LaTeX table.
% 
% Note:
%     To make a table fit in one page you can wrap the produced table in
%     "\resizebox*{!}{0.9\textheight}{" and "}". 
%
% See also STATS_TABLE_PER_SETUP.
%
% Copyright (c) 2015 Nuno Fachada
% Distributed under the MIT License (See accompanying file LICENSE or copy 
% at http://opensource.org/licenses/MIT)
%

% Output names
outputs = data.outputs;
nout = numel(outputs);

% Number of statistical summaries
ssumms_struct = stats_get();
ssumms = ssumms_struct.latex;
nssumms = numel(ssumms);

% Begin table
t = sprintf('\\begin{tabular}{ccrrrrrr}\n');
t = sprintf('%s\\toprule\n', t);

% Table header
t = sprintf('%s Out. & Stat.', t);
for i = 1:nssumms % Cycle through statistical summaries
    t = sprintf('%s & \\multicolumn{1}{c}{$%s$}', t, ssumms{i});
end;
t = sprintf('%s \\\\ \n', t);

% Cycle through all outputs
for i = 1:nout
        
    % Initialize statistics 
    ms = zeros(1, nssumms);
    vs = zeros(1, nssumms);
    sw = zeros(1, nssumms);
    s = zeros(1, nssumms);
    hists = cell(1, nssumms);
    qqs = cell(1, nssumms);
    
    % Cycle through all statistical summaries
    for j = 1:nssumms
        
        % What is the exact index of the focal measure being analyzed?
        idx = (i - 1) * nssumms + j;
            
        % Analyze current data
        [ms(j), vs(j), ~, ~, sw(j), s(j)] = ...
            stats_analyze(data.sdata(:, idx), 0.01);
        
        % Create data for histogram
        hists{j} = histc(data.sdata(:, idx), ...
            hist_edges(data.sdata(:, idx)));
        
        % Create data for qq plot
        qqs{j} = qqcalc(data.sdata(:, idx));
        
    end;
    
    % Print a midrule
    t = sprintf('%s\\midrule\n', t);
    
    % We could print the output variable here, but it looks better if we
    % put it before the Skewness.
    % t = sprintf('%s\\multirow{6}{*}{$%s$}\n', t, outputs{i});
    
    % Print the means
    t = sprintf('%s & $\\mean{X}(n)$', t);
    for j = 1:nssumms % Cycle through statistical summaries
        t = sprintf('%s & %s', t, ltxr(ms(j)));
    end;
    t = sprintf('%s \\\\ \n', t);
    
    % Print the variances
    t = sprintf('%s & $S^2(n)$', t);
    for j = 1:nssumms % Cycle through statistical summaries
        t = sprintf('%s & %s', t, ltxr(vs(j)));
    end;
    t = sprintf('%s \\\\ \n', t);

    % Print the p-values from the Shapiro-Wilk test
    t = sprintf('%s & SW', t);
    for j = 1:nssumms % Cycle through statistical summaries
        t = sprintf('%s & %s', t, ltxp(sw(j)));
    end;
    t = sprintf('%s \\\\ \n', t);
    
    % Print the output variable here, before the Skewness
    t = sprintf('%s %s\n', t, outputs{i});
    
    % Print the skewness
    t = sprintf('%s & Skew.', t);
    for j = 1:nssumms % Cycle through statistical summaries
        t = sprintf('%s & %s', t, ltxr(s(j)));
    end;
    t = sprintf('%s \\\\ \n', t);
    
    % Print the histograms
    t = sprintf('%s & Hist.', t);
    for j = 1:nssumms % Cycle through statistical summaries
        t = sprintf('%s & %s', t, hw(tikhist(hists{j})));
    end;
    t = sprintf('%s \\\\ \n', t);
    
    % Print the QQ-plots
    t = sprintf('%s & Q-Q', t);
    for j = 1:nssumms % Cycle through statistical summaries
        t = sprintf('%s & %s', t, qw(tikqq(qqs{j})));
    end;
    t = sprintf('%s \\\\ \n', t);

end;

% Finish table
t = sprintf('%s\\bottomrule\n', t);
t = sprintf('%s\\end{tabular}\n', t);

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Helper function to wrap a TikZ QQ-plot so that it floats and scales 
% properly when put in a table
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%
function out = qw(in)

out = sprintf(...
    '\\raisebox{-.5\\height}{\\resizebox {1.2cm} {1.2cm} {%s}}', ...
    in);

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Helper function to wrap a TikZ histogram so that it centers and scales
% properly when put in a table
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%
function out = hw(in)

out = sprintf('\\multicolumn{1}{c}{\\resizebox {!} {0.5cm} {%s}}', in);
