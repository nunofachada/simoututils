function [ps, h_all] = stats_compare(stats1, stats2, tests, alpha)
% STATS_COMPARE Compare focal measures from two model implementations by
% applying the specified statistical tests.
%
%   [ps, h_all] = STATS_COMPARE(stats1, stats2, tests, alpha)
%
% Parameters:
%   stats1 - Statistical summaries (given by the stats_gather function) 
%            from the first model implementation.
%   stats1 - Statistical summaries (given by the stats_gather function) 
%            from the second model implementation.
%    tests - 't' - t-test, 'mw' - Mann-Whitney, 'ks' - Kolmogrov-Smirnoff.
%            Can also be a cell array of strings, each string corresponding
%            to the test to apply to each of the six statistical summaries,
%            namely max, argmax, min, argmin, ss-mean and ss-std.
%            For example, {'t', 'mw', 't', 'mw', 't', 't'} will apply the 
%            t-test to all summaries except argmax and argmin, to which the
%            Mann-Whitney test is applied instead. Default is 't' (t-tests
%            for all statistical summaries).
%    alpha - Significante level for the tests (optional, default = 0.05).
%
% Outputs:
%      ps - Matrix of p-values for the requested tests, rows correspond to
%           outputs, columns to statistical summaries.
%   h_all - How many tests failed for the specified significance level.
%
%
% See also STATS_GATHER.
%
% Copyright (c) 2015 Nuno Fachada
% Distributed under the MIT License (See accompanying file LICENSE or copy 
% at http://opensource.org/licenses/MIT)
%


% Total tests failed
h_all = 0;

% Number of comparisons to perform
ncomps = size(stats1.sdata, 2);

% Vector of p-values (will be converted to matrix later)
ps = zeros(1, ncomps);

% Use default alpha?
if nargin < 4
    alpha = 0.05;
end;

% Use default tests?
if nargin < 3
    tests = {'t'};
end;

% Is tests a cell? If not make it so
if ~iscell(tests)
    tests = {tests};
end;


% Cycle through all focal measures and perform requested tests
for i=1:ncomps
    
    [h, ps(i)] = dotest(tests{mod(i - 1, numel(tests)) + 1}, ...
        stats1.sdata(:, i), stats2.sdata(:, i), alpha);
    h_all = h_all + h;

end;

% Convert vector of p-values to matrix (rows correspond to outputs, columns
% to statistical summaries).
ps = reshape(ps, 6, numel(stats1.outputs))';

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% %
% Helper function to perform the actual tests %
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% %
function [h, p] = dotest(test, sample1, sample2, alpha)
        
if numel(unique(sample1)) == 1 && numel(unique(sample2)) == 1 ...
        && sample1(1) == sample2(1)
    
    % Avoid testing if both samples only have the same unique value
    h = 0;
    p = 1;
    
elseif strcmp(test, 't')
    
    % t-test
    if is_octave()
        p = t_test_2(sample1, sample2);
        h = p < alpha;
    else
        [h, p] = ttest2(sample1, sample2, 'Alpha', alpha);
    end;

elseif strcmp(test, 'mw')
    
    % Mann-Whitney
    if is_octave()
        p = u_test(sample1, sample2);
        h = p < alpha;
    else
        [p, h] = ranksum(sample1, sample2, 'Alpha', alpha);
    end;
    
elseif strcmp(test, 'ks')
    
    % Kolmogrov-Smirnoff
    if is_octave()
        p = kolmogorov_smirnov_test_2(sample1, sample2);
        h = p < alpha;
    else
        [h, p] = kstest2(sample1, sample2, 'Alpha', alpha);
    end;
    
else
    
    % Unknown test
    error(['Unknown test ' test]);
    
end;
