function y = mavg(x, w)
% MAVG Applies a moving average (low-pass) filter to vector x using a
% window of size w.
%
%   y = MAVG(x, w)
%
% Parameters:
%       x - Input vector.
%       w - Size of moving average window.
%
% Returns:
%       y - Output vector, after moving average filter.
%
% Details:
%   The format of the data in each file is the following: columns 
%   correspond to outputs, while rows correspond to iterations.
%
% Copyright (c) 2015 Nuno Fachada
% Distributed under the MIT License (See accompanying file LICENSE or copy 
% at http://opensource.org/licenses/MIT)
%

y = zeros(numel(x) - w, 1);
for i = 1:numel(y)
    if i <= w
        y(i) = sum(x((i - (i - 1)):(i + (i - 1)))) / (2 * i - 1);
    else
        y(i) = sum(x((i - w):(i + w))) / (2 * w + 1);
    end;
end;