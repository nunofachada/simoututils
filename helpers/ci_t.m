function ci = ci_t(data, alpha)
% CI_T Obtain a t-confidence interval.
%
%   ci = CI_T(data, alpha)
%
% Parameters:
%  data - Vector with data.
% alpha - Significance level for confidence interval.
%
% Returns:
%    ci - A vector of two elements establishing the limits of the 
%         t-confidence interval.
% 
% Copyright (c) 2015 Nuno Fachada
% Distributed under the MIT License (See accompanying file LICENSE or copy 
% at http://opensource.org/licenses/MIT)
%

% Sample size
n = numel(data);

% Sample mean
mu = mean(data); 

% Sample standard deviation of the mean
s = std(data) / sqrt(n);

% Interval half-length
hl = tinv(1 - alpha / 2, n - 1) * s;

% Return confidence interval
ci = [mu -  hl, mu + hl];
