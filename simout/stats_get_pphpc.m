function sdata = stats_get_pphpc(args, file, num_outputs)
% STATS_GET_PPHPC Obtain the max, argmax, min, argmin, mean and std 
% statistical summaries from simulation outputs given in a file.
%
%   stats = STATS_GET_PPHPC(args, file, num_outputs)
%
% Parameters:
%        args - Iteration after which outputs are in steady-state (for mean
%               and std statistical summaries).
%       file  - File containing simulation outputs, columns correspond to 
%               outputs, rows correspond to iterations.
% num_outputs - Number of outputs in file.
%
% Returns:
%       sdata - A 6 x num_outputs matrix, with 6 statistical summaries and
%               num_outputs outputs. If no arguments are given, this
%               function returns a struct with two fields:
%               text - Cell array of strings containing the names of the
%                      statistical measures in plain text.
%              latex - Cell array of strings containing the names of the
%                      statistical measures in LaTeX format.
%
% Notes:
%   - The format of the data in each file is the following: columns 
%     correspond to outputs, while rows correspond to iterations.
%   - The names of the statistical summaries in LaTeX format assume the
%     following LaTeX definitions:
%       % For \argmax and \argmin
%       \@ifpackageloaded{amsmath}{
%           \DeclareMathOperator*{\argmax}{arg\,max}
%           \DeclareMathOperator*{\argmin}{arg\,min}}
%           {}
%       \makeatother
%       % For \mean
%       \newcommand*\mean[1]{\overline{#1}}
%
%
% Copyright (c) 2015 Nuno Fachada
% Distributed under the MIT License (See accompanying file LICENSE or copy 
% at http://opensource.org/licenses/MIT)
%

% The first argument is the steady-state truncation point.
ss_idx = args;

% If only the first argument is given...
if nargin == 1
    % ...return names of statistic summaries
    sdata = struct(...
        'text', {{'max', 'argmax', 'min', 'argmin', 'mean', 'std'}}, ...
        'latex', {{'\max', '\argmax', '\min', '\argmin', ...
            '\mean{X}^{\text{ss}}', 'S^{\text{ss}}'}});
    return;
end;

% Read stats file
data = dlmread(file);
dataLen = size(data, 1);

% Initialize stats matrix
sdata = zeros(6, num_outputs);

% Determine stats for each of the outputs
for i = 1:num_outputs
    
    % Iterations start at zero, but Matlab starts indexing at 1, so we have
    % to subtract index by one.
    
    % Get current output
    curOutput = data(:, i);
    % Get maximum
    curMax = max(curOutput);
    % Get iteration where maximum occurs
    curArgMax = find(curOutput == curMax, 1) - 1;
    % Get minimum
    curMin = min(curOutput);
    % Get iteration where minimum occurs
    curArgMin = find(curOutput == curMin, 1) - 1;
    % Get steady-state mean
    curMean = mean(curOutput((ss_idx + 1):dataLen));
    % Get steady-state standard deviation
    curStd = std(curOutput((ss_idx + 1):dataLen));
 
    % Place current output statistics in output variable
    sdata(:, i) = [curMax; curArgMax; curMin; curArgMin; curMean; curStd];
    
end;