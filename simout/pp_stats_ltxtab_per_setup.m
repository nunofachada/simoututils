function t = pp_stats_ltxtab_per_setup(data)
% PP_STATS_LTXTAB_PER_SETUP Outputs a LaTeX table with a distributional
% analysis of a PPHPC for one setup/configuration for all focal measures.
% For each focal measure, the table shows the mean, variance, p-value of
% the Shapiro-Wilk test, skewness, histogram and QQ-plot. Requires the 
% siunitx, multirow and booktabs LaTeX packages.
%
%   t = PP_STATS_LTXTAB_PER_SETUP(data)
%
% Parameters:
%      data - Stats returned by the stats_gather function for the desired
%             model setup/configuration.
%
% Returns:
%      t - A string containing the LaTeX table.
% 
% Note:
%     To make a table fit in one page you can wrap the produced table in
%     "\resizebox*{!}{0.9\textheight}{" and "}". 
%
% Copyright (c) 2015 Nuno Fachada
% Distributed under the MIT License (See accompanying file LICENSE or copy 
% at http://opensource.org/licenses/MIT)
%

% Outputs and statistical summaries
outputs = {'P_i^s', 'P_i^w', 'P_i^c', '\mean{E}^s_i', '\mean{E}^w_i', ...
    '\mean{C}_i'};
ssumm = {'\max', '\argmax', '\min', '\argmin', '\mean{X}^{\text{ss}}',...
    'S^{\text{ss}}'};

% Begin table
t = sprintf('\\begin{tabular}{ccrrrrrr}\n');
t = sprintf('%s\\toprule\n', t);

% Table header
t = sprintf(['%s Out. & Stat. & \\multicolumn{1}{c}{$%s$} & ' ...
    '\\multicolumn{1}{c}{$%s$} & \\multicolumn{1}{c}{$%s$} & ' ...
    '\\multicolumn{1}{c}{$%s$} & \\multicolumn{1}{c}{$%s$} & ' ...
    '\\multicolumn{1}{c}{$%s$} \\\\ \n'], ...
    t, ...
    ssumm{1}, ssumm{2}, ssumm{3}, ...
    ssumm{4}, ssumm{5}, ssumm{6});

% Cycle through all outputs
for i=1:numel(outputs)
        
    % Initialize statistics 
    ms = zeros(1, numel(ssumm));
    vs = zeros(1, numel(ssumm));
    sw = zeros(1, numel(ssumm));
    s = zeros(1, numel(ssumm));
    hists = cell(1, numel(ssumm));
    qqs = cell(1, numel(ssumm));
    
    % Cycle through all statistical summaries
    for j=1:numel(ssumm)
        
        % What is the exact index of the focal measure being analyzed?
        idx = (i - 1) * numel(ssumm) + j;
            
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
    t = sprintf(...
        '%s & $\\mean{X}(n)$ & %s & %s & %s & %s & %s & %s \\\\ \n', ...
        t, ...
        ltxr(ms(1)), ltxr(ms(2)), ltxr(ms(3)), ...
        ltxr(ms(4)), ltxr(ms(5)), ltxr(ms(6)));
    
    % Print the variances
    t = sprintf(...
        '%s & $S^2(n)$      & %s & %s & %s & %s & %s & %s \\\\ \n', ...
        t, ...
        ltxr(vs(1)), ltxr(vs(2)), ltxr(vs(3)), ...
        ltxr(vs(4)), ltxr(vs(5)), ltxr(vs(6)));
    % Print the p-values from the Shapiro-Wilk test
    t = sprintf(...
        '%s & SW            & %s & %s & %s & %s & %s & %s \\\\ \n', ...
        t, ...
        ltxp(sw(1)), ltxp(sw(2)), ltxp(sw(3)),...
        ltxp(sw(4)), ltxp(sw(5)), ltxp(sw(6)));
    
    % Print the output variable here, before the Skewness
    t = sprintf('%s $%s$\n', t, outputs{i});
    
    % Print the skewness
    t = sprintf(...
        '%s & Skew.         & %s & %s & %s & %s & %s & %s \\\\ \n', ...
        t, ...
        ltxr(s(1)), ltxr(s(2)), ltxr(s(3)), ...
        ltxr(s(4)), ltxr(s(5)), ltxr(s(6)));
    
    % Print the histograms
    t = sprintf(...
        '%s & Hist.         & %s & %s & %s & %s & %s & %s \\\\ \n', ...
        t, ...
        hw(tikhist(hists{1})), hw(tikhist(hists{2})), ...
        hw(tikhist(hists{3})), hw(tikhist(hists{4})), ...
        hw(tikhist(hists{5})), hw(tikhist(hists{6})));
    
    % Print the QQ-plots
    t = sprintf(...
        '%s & Q-Q           & %s & %s & %s & %s & %s & %s \\\\ \n', ...
        t, ...
        qw(tikqq(qqs{1})), qw(tikqq(qqs{2})), qw(tikqq(qqs{3})), ...
        qw(tikqq(qqs{4})), qw(tikqq(qqs{5})), qw(tikqq(qqs{6})));

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
