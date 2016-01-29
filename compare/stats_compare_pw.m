function [t, h_all] = stats_compare_pw(alpha, tests, adjust, varargin)
% STATS_COMPARE_PW Compare focal measures from multiple model 
% implementations, pair-wise, by applying the specified two-sample
% statistical tests. This function outputs a plain text table of pair-wise 
% failed tests.
%
%   [t, h_all] = STATS_COMPARE_PW(alpha, tests, adjust, varargin)
%
% Parameters:
%    alpha - Significante level for the tests.
%    tests - 'p' - t-test, 'np' - Mann-Whitney. Can also be a cell array of
%            strings, each string corresponding to the test to apply to 
%            each of the statistical summaries produced by the stats_get
%            function.
%   adjust - Adjust p-values for comparison of multiple focal measures?
%            Available options are: 'holm', 'hochberg', 'hommel',
%            'bonferroni', 'BH', 'BY' or 'none'.
% varargin - Statistical summaries (given by the stats_gather function) 
%            for each implementation.
%
% Outputs:
%        t - String containing plain text table of pair-wise failed tests.
%    h_all - Matrix of pair-wise failed tests.
%
%
% See also STATS_COMPARE.
%
% Copyright (c) 2015 Nuno Fachada
% Distributed under the MIT License (See accompanying file LICENSE or copy 
% at http://opensource.org/licenses/MIT)
%

% Number of implementations
num_impls = nargin - 3;

% Matrix of failed tests
h_all = zeros(num_impls, num_impls);

% Compare all implementations pair-wise
for i = 1:num_impls
    for j = (i + 1):num_impls
        
        % Compare implementations i and j
        [~, fails] = stats_compare(...
            alpha, tests, adjust, varargin{i}, varargin{j});
        
        % Update matrix of failed tests
        h_all(i, j) = h_all(i, j) + fails;
        h_all(j, i) = h_all(j, i) + fails;
        
    end;
end;

% Output a plain text table of failed tests
if is_octave(), t = sprintf('\n');
else t = '';
end;
    
t = sprintf('%s %12.12s', t, ' ');
for i = 1:num_impls
    t = sprintf('%s--------------', t);
end;
t = sprintf('%s-\n', t);

t = sprintf('%s %11.11s', t, ' ');
for i = 1:num_impls
    t = sprintf('%s | %11.11s', t, varargin{i}.name);
end;
t = sprintf('%s |\n', t);

for i = 1:(num_impls + 1)
    t = sprintf('%s--------------', t);
end;
t = sprintf('%s\n', t);

for i = 1:num_impls
    t = sprintf('%s| %10.10s', t, varargin{i}.name);
    for j = 1:num_impls
        t = sprintf('%s | %11d', t, h_all(i,j));
    end;
    t = sprintf('%s |\n', t);
end;

for i = 1:(num_impls + 1)
    t = sprintf('%s--------------', t);
end;
t = sprintf('%s\n', t);
