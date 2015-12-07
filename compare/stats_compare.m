function [ps, h_all] = stats_compare(alpha, tests, varargin)
% STATS_COMPARE Compare focal measures from two or more model 
% implementations by applying the specified statistical tests.
%
%   [ps, h_all] = STATS_COMPARE(alpha, tests, varargin)
%
% Parameters:
%    alpha - Significante level for the tests.
%    tests - Either 'p' or 'np', for parametric or non-parametric tests,
%            respectively. The parametric tests are the t-test and ANOVA
%            when comparing two or more models, respectively. The
%            non-parametric tests are Mann-Whitney or Kruskal-Wallis when
%            comparing two or more models, respectively. Can also be a 
%            cell array of strings, each string corresponding to the test 
%            to apply to each of the six statistical summaries, namely max, 
%            argmax, min, argmin, ss-mean and ss-std. For example, 
%            {'p', 'np', 'p', 'np', 'p', 'p'} will apply a parametric test
%            to all summaries except argmax and argmin, to which a
%            non-parametric test is applied instead.
% varargin - Statistical summaries (given by the stats_gather function) 
%            for each implementation.
%
% Outputs:
%       ps - Matrix of p-values for the requested tests, rows correspond to
%            outputs, columns to statistical summaries.
%    h_all - How many tests failed for the specified significance level.
%
% Copyright (c) 2015 Nuno Fachada
% Distributed under the MIT License (See accompanying file LICENSE or copy 
% at http://opensource.org/licenses/MIT)
%

% Number of implementations
nimpl = nargin - 2;

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

% Vector of p-values (will be reshaped into a matrix later)
ps = zeros(1, 6 * nout);

% Total failed tests
h_all = 0;

% Cycle through focal measures
for i = 1:(6 * nout)
    
    % Get sample from each implementation for current focal measure
    cmpdata = zeros(size(varargin{1}.sdata, 1), nimpl);
    for j = 1:nimpl
        cmpdata(:, j) = varargin{j}.sdata(:, i);
    end;

    % Perform statistical test
    ps(i) = dotest(tests{mod(i - 1, numel(tests)) + 1}, cmpdata, inames);
    
    % Did the test succeed?
    h_all = h_all + (ps(i) < alpha);
    
end;

% Convert vector of p-values to matrix (rows correspond to outputs, columns
% to statistical summaries).
ps = reshape(ps, 6, nout)';

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
    
elseif strcmp(test, 'np')
    
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

            % Stupid way to do this in Octave, but is there any other way?
            switch size(data, 2)
                case 2
                    p = kruskal_wallis_test(data(:, 1), data(:, 2));
                case 3
                    p = kruskal_wallis_test(data(:, 1), data(:, 2), ...
                        data(:, 3));
                case 4
                    p = kruskal_wallis_test(data(:, 1), data(:, 2), ...
                        data(:, 3), data(:, 4));
                case 5
                    p = kruskal_wallis_test(data(:, 1), data(:, 2), ...
                        data(:, 3), data(:, 4), data(:, 5));
                case 6
                    p = kruskal_wallis_test(data(:, 1), data(:, 2), ...
                        data(:, 3), data(:, 4), data(:, 5), data(:, 6));
                case 7
                    p = kruskal_wallis_test(data(:, 1), data(:, 2), ...
                        data(:, 3), data(:, 4), data(:, 5), data(:, 6), ...
                        data(:, 7));
                case 8
                    p = kruskal_wallis_test(data(:, 1), data(:, 2), ...
                        data(:, 3), data(:, 4), data(:, 5), data(:, 6), ...
                        data(:, 7), data(:, 8));
                case 9
                    p = kruskal_wallis_test(data(:, 1), data(:, 2), ...
                        data(:, 3), data(:, 4), data(:, 5), data(:, 6), ...
                        data(:, 7), data(:, 8), data(:, 9));
                case 10
                    p = kruskal_wallis_test(data(:, 1), data(:, 2), ...
                        data(:, 3), data(:, 4), data(:, 5), data(:, 6), ...
                        data(:, 7), data(:, 8), data(:, 9), data(:, 10));
                otherwise
                    error(['Cannot perform the Kruskal-Wallis test with more'...
                        ' than 10 implementations in Octave.']);
            end;

        else

            % With MATLAB
            p = kruskalwallis(data, inames, 'off');

        end;
    end;
else
    
    % Unknown test
    error(['Unknown test ' test]);
    
end;
    
    
