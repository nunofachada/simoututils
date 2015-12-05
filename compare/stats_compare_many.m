function h_all = stats_compare_many(alpha, tests, varargin)
% STATS_COMPARE_MANY Compare focal measures from multiple model 
% implementations, pair-wise, by applying the specified statistical tests.
% This function prints a table of pair-wise failed tests.
%
%   h_all = STATS_COMPARE_MANY(alpha, tests, varargin)
%
% Parameters:
%    alpha - Significante level for the tests.
%    tests - 't' - t-test, 'mw' - Mann-Whitney, 'ks' - Kolmogrov-Smirnoff.
%            Can also be a cell array of strings, each string corresponding
%            to the test to apply to each of the six statistical summaries,
%            namely max, argmax, min, argmin, ss-mean and ss-std. For 
%            example, {'t', 'mw', 't', 'mw', 't', 't'} will apply the 
%            t-test to all summaries except argmax and argmin, to which the
%            Mann-Whitney test is applied instead.
% varargin - Statistical summaries (given by the stats_gather function) 
%            for each implementation.
%
% Outputs:
%    h_all - Matrix of pair-wise failed tests.
%
%
% See also STATS_GATHER.
%
% Copyright (c) 2015 Nuno Fachada
% Distributed under the MIT License (See accompanying file LICENSE or copy 
% at http://opensource.org/licenses/MIT)
%

% Number of datasets
numDataSets = nargin - 2;

% Matrix of failed tests
h_all = zeros(numDataSets, numDataSets);

% Compare all datasets with each other
for i = 1:numDataSets
    for j = (i + 1):numDataSets
        
        % Compare datasets i and j
        [~, fails] = stats_compare(varargin{i}, varargin{j}, tests, alpha);
        
        % Update matrix of failed tests
        h_all(i, j) = h_all(i, j) + fails;
        h_all(j, i) = h_all(j, i) + fails;
        
    end;
end;

% Print a table of failed tests
fprintf(1, ' %12.12s', ' ');
for i = 1:numDataSets
    fprintf(1, '--------------');
end;
fprintf(1, '-\n');

fprintf(1, ' %11.11s', ' ');
for i = 1:numDataSets
    fprintf(1, ' | %11.11s', varargin{i}.name);
end;
fprintf(1, ' |\n');

for i = 1:(numDataSets + 1)
    fprintf(1, '--------------');
end;
fprintf(1, '\n');

for i = 1:numDataSets
    fprintf(1, '| %10.10s', varargin{i}.name);
    for j = 1:numDataSets
        fprintf(1, ' | %11d', h_all(i,j));
    end;
    fprintf(1, ' |\n');
end;

for i = 1:(numDataSets + 1)
    fprintf(1, '--------------');
end;
fprintf(1, '\n');
