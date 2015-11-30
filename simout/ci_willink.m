function ci = ci_willink(data, alpha)
% CI_WILLINK Obtain a Willink confidence interval.
%
%   ci = CI_WILLINK(data, alpha)
%
% Parameters:
%  data - Vector with data.
% alpha - Significance level for confidence interval.
%
% Returns:
%    ci - A vector of two elements establishing the limits of the 
%         Willink confidence interval.
%
% Reference:
%     Willink, R. (2005). A confidence interval and test for the mean of an
%     asymmetric distribution. Commun. Stat. Theor. M., 34(4):753–766.
%
% Copyright (c) 2015 Nuno Fachada
% Distributed under the MIT License (See accompanying file LICENSE or copy 
% at http://opensource.org/licenses/MIT)
%

% Sample size
n = numel(data);

% Sample mean 
mu = mean(data);

% Determine mu3
mu3 = n * sum((data - mu).^3) / ((n - 1) * (n - 2));

% Determine a
a = mu3 / (6 * sqrt(n) * var(data)^(3/2));

% Sample standard deviation of the mean
s = std(data) / sqrt(n);

% Return confidence interval
ci = [mu - G(tinv(1 - alpha / 2, n - 1), a) * s, ...
    mu - G(-tinv(1 - alpha / 2, n - 1), a) * s];


% G(r) function
function g = G(r, a)

g = ((1 + 6 * a * (r - a))^(1/3) - 1) / (2 * a);
