function t = stats_table_per_setup(data, alpha, format)
% STATS_TABLE_PER_SETUP Outputs a plain text or LaTeX table with the
% statistics returned by the stats_analyze function for all focal measures
% for one model setup/configuration.
%
%   STATS_TABLE_PER_SETUP(data, alpha, format)
%
% Parameters:
%   data - Object returned by the stats_gather function for one model 
%          setup/configuration.
%  alpha - Significance level for confidence intervals and Shapiro-Wilk
%          test.
% format - Either 0 for plain text format, or 1 for LaTeX format (the
%          latter requires the siunitx, multirow, booktabs, and ulem 
%          packages).
%
% Returns:
%      t - A string containing the LaTeX table.
% 
% See also STATS_ANALYZE, DIST_TABLE_PER_SETUP.
% 
% Copyright (c) 2015 Nuno Fachada
% Distributed under the MIT License (See accompanying file LICENSE or copy 
% at http://opensource.org/licenses/MIT)
%

% Analyze the statistics
[m, v, c, ~, sw, ~] = stats_analyze(data.sdata, alpha);

% Output names
outputs = data.outputs;

% What type of table to print?
if format == 0
    
    % Matlab format
    
    ssumms = {'max','argmax','min','argmin','mean','std'};
    numssum = numel(ssumms);
    idx = 0;
    
    t = sprintf('-----------------------------------------------------------------------------------------\n');
    t = sprintf('%s|   Output   | F. meas. |    Mean    |  Variance  |  % 2d%% Confidence interval | SW test |\n', ...
        t, round(100 * (1 - alpha)));
    for outp = outputs
        for ssumm = ssumms
            idx = idx + 1;
            if rem(idx, numssum) == 1
                t = sprintf('%s|------------|----------|------------|------------|---------------------------|---------|\n',...
                    t);
                t = sprintf('%s| % 10s ', t, outp{1});
            else
                t = sprintf('%s| % 10s ', t, ' ');
            end;
            t = sprintf('%s| % 8s | % 10.4g | % 10.4g | [ %10.4g, %10.4g] | % 6.4f |\n', ...
                t, ssumm{1}, m(idx), v(idx), c(idx, 1), c(idx, 2), sw(idx));
        end;
    end;
    t = sprintf('%s-----------------------------------------------------------------------------------------\n', ...
        t);
    
else
    
    % Latex format
    
    ssumms = {'\max', '\argmax', '\min', '\argmin', ...
        '\mean{X}^{\text{ss}}', 'S^{\text{ss}}'};
    numssum = numel(ssumms);
    idx = 0;
    
    t = sprintf('\\begin{tabular}{clrrcr}\n');
    t = sprintf('%s\\toprule\n', t);
    t = sprintf('%sOut. & Stat. & $\\bar{X}(n)$ & $S^2(n)$ & $t$ Conf. int. & SW test\\\\\n', ...
        t);
    for outp = outputs
        for ssumm = ssumms
            idx = idx + 1;
            if rem(idx, numssum) == 1
                t = sprintf('%s\\midrule\n', t);
                t = sprintf('%s\\multirow{6}{*}{%s}\n', t, outp{1});
            end;
            
            if c(idx, 2) == c(idx, 1)
                ci = '$[\text{-}, \text{-}]$';
            else
                ci = sprintf('$[ %s, % s]$', ...
                    ltxr(c(idx, 1)), ltxr(c(idx, 2)));
            end;
            
            t = sprintf('%s & $%s$ & $%s$ & $%s$ & %s & % 31s\\\\\n', ...
                t, ...
                ssumm{1}, ltxr(m(idx)), ltxr(v(idx)), ci, ltxpe(sw(idx)));
        end;
    end;
    t = sprintf('%s\\bottomrule\n', t);
    t = sprintf('%s\\end{tabular}\n', t);
    
end;
