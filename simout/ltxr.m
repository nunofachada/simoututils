function lvalue = ltxr(value)
% LTXR Formats a real value for LaTeX (requires LaTeX siunitx package).
%
%   lvalue = LTXR(value)
%
% Parameters:
%   value - Real value to format.
%
% Returns:
%  lvalue - A string with the formatted value, according to the following
%           rules:
%             * If value is NaN, return '-'.
%             * If value is 0, return '0'.
%             * If absolute value is between 0.0005 and 1, return formatted
%               value with three decimal digits.
%             * If absolute value is between 1 and 100, return formatted
%               value with two decimal digits.
%             * If absolute value is between 100 and 1000, return formatted
%               value with one decimal digit.
%             * Otherwise return value with two decimal digits in
%               scientific notation.
% 
% Copyright (c) 2015 Nuno Fachada
% Distributed under the MIT License (See accompanying file LICENSE or copy 
% at http://opensource.org/licenses/MIT)
%

if isnan(value)
    lvalue = '-';
elseif value == 0
    lvalue = '0';
elseif abs(value) > 0.0005 && value < 1
    lvalue = sprintf('\\num{% 6.3f}', value);
elseif abs(value) >=1 && value < 100
    lvalue = sprintf('\\num{% 6.2f}', value);
elseif abs(value) >= 100 && value < 1000
    lvalue = sprintf('\\num{% 6.1f}', value);
else
    lvalue = sprintf(['\\num[scientific-notation=true,' ...
        'exponent-product=\\cdot]{% 6.2e}'], value);
end;

