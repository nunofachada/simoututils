function [ps, h_all] = stats_compare(alpha, tests, adjust, varargin)
% STATS_COMPARE Compare focal measures from two or more model 
% implementations by applying the specified statistical tests.
%
%   [ps, h_all] = STATS_COMPARE(alpha, tests, adjust, varargin)
%
% Parameters:
%    alpha - Significante level for the tests.
%    tests - Either 'p' or 'np', for parametric or non-parametric tests,
%            respectively. The parametric tests are the t-test and ANOVA
%            when comparing two or more models, respectively. The
%            non-parametric tests are Mann-Whitney or Kruskal-Wallis when
%            comparing two or more models, respectively. Can also be a 
%            cell array of strings, each string corresponding to the test 
%            to apply to each statistical summary returned by stats_get.
%   adjust - Adjust p-values for comparison of multiple focal measures?
%            Available options are: 'holm', 'hochberg', 'hommel',
%            'bonferroni', 'BH', 'BY', 'sidak' or 'none'.
% varargin - Statistical summaries (given by the stats_gather function) 
%            for each implementation.
%
% Outputs:
%       ps - Matrix of p-values for the requested tests, rows correspond to
%            outputs, columns to statistical summaries.
%    h_all - How many tests failed for the specified significance level.
%
% Copyright (c) 2016 Nuno Fachada
% Distributed under the MIT License (See accompanying file LICENSE or copy 
% at http://opensource.org/licenses/MIT)
%

% Number of implementations
nimpl = nargin - 3;

% Implementation names
inames = cell(1, nimpl);
for i = 1:nimpl
    inames{i} = varargin{i}.name;
end;

% Is tests a cell? If not make it so
if ~iscell(tests)
    tests = {tests};
end;

% Number of outputs
nout = numel(varargin{1}.outputs);

% Number of statistical summaries
ssumms = varargin{1}.ssnames;
nssumms = numel(ssumms.text);

% Vector of p-values (will be reshaped into a matrix later)
ps = zeros(1, nssumms * nout);

% Cycle through focal measures
for i = 1:(nssumms * nout)
    
    % Get sample from each implementation for current focal measure
    cmpdata = zeros(size(varargin{1}.sdata, 1), nimpl);
    for j = 1:nimpl
        cmpdata(:, j) = varargin{j}.sdata(:, i);
    end;

    % Perform statistical test
    ps(i) = dotest(tests{mod(i - 1, numel(tests)) + 1}, cmpdata, inames);
    
end;

% Convert vector of p-values to matrix (rows correspond to outputs, columns
% to statistical summaries).
ps = reshape(ps, nssumms, nout)';

% Perform p-value correction, if any
ps = pval_adjust(ps, adjust);

% How many tests failed?
h_all = sum(reshape(ps < alpha, 1, numel(ps)));

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% %
% Helper function to perform the actual tests %
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% %
function p = dotest(test, data, inames)

% How many implementations to compare?
nimpl = size(data, 2);

if numel(unique(data)) == 1
    
    % Avoid testing if all samples only have the same unique value
    p = 1;
    
elseif strcmp(test, 'p') % Parametric test
    
    % Use t-test for two-samples, ANOVA for n samples
    if nimpl == 2
        
        % t-test
        if is_octave()
            p = t_test_2(data(:, 1), data(:, 2));
        else
            [~, p] = ttest2(data(:, 1), data(:, 2));
        end;
        
    else
        
        % ANOVA
        if is_octave()
            p = anova(data);
        else
            p = anova1(data, inames, 'off');
        end;
        
    end;
    
elseif strcmp(test, 'np') % Non-parametric test
    
    % Use Mann-Whitney for two-samples, Kruskal-Wallis for n samples
    if nimpl == 2
        
        % Mann-Whitney
        if is_octave()
            p = u_test(data(:, 1), data(:, 2));
        else
            p = ranksum(data(:, 1), data(:, 2));
        end;        
        
    else
        
        % Kruskal-Wallis
        if is_octave()
            cdata = num2cell(data, 1);
            p = kruskal_wallis_test(cdata{:});
        else
            p = kruskalwallis(data, inames, 'off');
        end;

    end;
else
    
    % Unknown test
    error(['Unknown test ' test]);
    
end;
    
    
