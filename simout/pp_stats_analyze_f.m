function pp_stats_analyze_f(data, alpha, format)
% PP_STATS_ANALYZE_F Print a table of focal measures (obtained with the
% stats_analyze function) formatted in plain text or in LaTeX (the latter 
% requires the siunitx, multirow, booktabs and ulem packages).
%
%   PP_STATS_ANALYZE_F(data, alpha, format)
%
% Parameters:
%   data - Data to analyze, n x m matrix, n observations, m statistical
%          summaries.
%  alpha - Significance level for confidence intervals and Shapiro-Wilk
%          test.
% format - Either 0 for plain text format, or 1 for LaTeX format.
%
% Note:
%     This function prints approximately the same data returned by the 
%     stats_analyze function, i.e. for each focal measure this function
%     displays the mean, variance, t-confidence interval and the p-value
%     of the Shappiro-Wilk test.
%
% See also STATS_ANALYZE.
% 
% Copyright (c) 2015 Nuno Fachada
% Distributed under the MIT License (See accompanying file LICENSE or copy 
% at http://opensource.org/licenses/MIT)
%

% Analyze the statistics
[m, v, c, ~, sw, ~] = stats_analyze(data, alpha);

if format == 0
    
    % Matlab format?
    tags = {'Sheep pop.', 'Wolf pop.', 'Grass qty.', 'Sheep en.', ...
        'Wolf en.', 'Grass en.'};
    subtags = {'max','argmax','min','argmin','mean','std'};
    numsubtags = numel(subtags);
    idx = 0;
    
    fprintf('-----------------------------------------------------------------------------------------\n');
    fprintf('|   Output   | F. meas. |    Mean    |  Variance  |  % 2d%% Confidence interval | SW test |\n', ...
        round(100 * (1 - alpha)));
    for tag = tags
        for subtag = subtags
            idx = idx + 1;
            if rem(idx, numsubtags) == 1
                fprintf('|------------|----------|------------|------------|---------------------------|---------|\n');
                fprintf('| % 10s ', tag{1});
            else
                fprintf('| % 10s ', ' ');
            end;
            fprintf('| % 8s | % 10.4g | % 10.4g | [ %10.4g, %10.4g] | % 6.4f |\n', ...
                subtag{1}, m(idx), v(idx), c(idx, 1), c(idx, 2), sw(idx));
        end;
    end;
    fprintf('-----------------------------------------------------------------------------------------\n');
    
else
    
    % Latex format?
    tags = {'P_i^s', 'P_i^w', 'P_i^c', '\bar{E}^s_i', '\bar{E}^w_i', '\bar{C}_i'};
    subtags = {'\max', '\argmax', '\min', '\argmin', ...
        '\mean{X}^{\text{ss}}', 'S^{\text{ss}}'};
    numsubtags = numel(subtags);
    idx = 0;
    
    fprintf('\\begin{tabular}{clrrcr}\n');
    fprintf('\\toprule\n');
    fprintf('Out. & Stat. & $\\bar{X}(n)$ & $S^2(n)$ & $t$ Conf. int. & SW test\\\\\n');
    for tag = tags
        for subtag = subtags
            idx = idx + 1;
            if rem(idx, numsubtags) == 1
                fprintf('\\midrule\n');
                fprintf('\\multirow{6}{*}{$%s$}\n', tag{1});
            end;
            
            if c(idx, 2) == c(idx, 1)
                ci = '$[\text{-}, \text{-}]$';
            else
                ci = sprintf('$[ %s, % s]$', ...
                    ltxr(c(idx, 1)), ltxr(c(idx, 2)));
            end;
            
            fprintf(' & $%s$ & $%s$ & $%s$ & %s & % 31s\\\\\n', ...
                subtag{1}, ltxr(m(idx)), ltxr(v(idx)), ci, ltxpe(sw(idx)));
        end;
    end;
    fprintf('\\bottomrule\n');
    fprintf('\\end{tabular}\n');
    
end;




    