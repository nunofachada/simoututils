function p = qqcalc(x)
% QQCALC Calculates the (normalized) points for a QQ-plot of the specified
% sample data versus the normal distribution.
%
%   p = QQCALC(x)
%
% Parameters:
%      x - Sample vector taken from a population with some distribution.
%
% Returns:
%      p - A struct with the following fields:
%           xx - Horizontal coordinates of the QQ-plot points.
%           yy - Vertical coordinates of the QQ-plot points.
%          lxx - Horizontal coordinates of the x=y line.
%          lyy - Vertical coordinates of the x=y line.
% 
% Example:
%     x = randn(1000, 1);
%     p = qqcalc(x);
%     plot(p.lxx, p.lyy,'r-');
%     hold on;
%     plot(p.xx, p.yy, 'k.');
%
% Copyright (c) 2015 Nuno Fachada
% Distributed under the MIT License (See accompanying file LICENSE or copy 
% at http://opensource.org/licenses/MIT)
%

% Normalize data
x = x - mean(x);
if var(x) > 0
    x= x / std(x);
end;

% Sort points
s = sort(x);

% Get some equally spaced values from which to obtain a standard normal
% distribution
n = length(x);
t = ((1 : n)' - .5) / n;

% Obtain a standard normal distribution
if ~is_octave()
    q = icdf('normal', t, 0,1);
else
    q = stdnormal_inv(t);
end;

% Normalize the data points using the maximum value
d = max(max(abs(q)), max(abs(s)));
if d == 0, d = 1; end;

xx = q / d;
yy = s / d;

% Determine two points for the normal line
lxx = [min(xx) max(xx)];
if var(x) > 0
    lyy = [min(xx) max(xx)];
else
    lyy = [0 0];
end;

% Extend the normal line a bit, say 10% on the x axis
m = (lyy(2) - lyy(1)) / (lxx(2) - lxx(1)); % slope
b = lyy(1) - m * lxx(1);

lxx = lxx * 1.1; % 10% increase
lyy = [(m * lxx(1) + b) (m * lxx(2) + b)];

% Return struct
p = struct('xx', xx, 'yy', yy', 'lxx', lxx, 'lyy', lyy);
