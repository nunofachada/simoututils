function lvalue = ltxpe(pvalue)
% LTXPE Formats a p-value for LaTeX, using exponents for very low 
% p-values and underlining (double-underlining) values below 0.05 (0.01).
% Requires siunitx and ulem LaTeX packages.
%
%   lvalue = LTXPE(value)
%
% Parameters:
%   value - P-value to format.
%
% Returns:
%  lvalue - A string with the formatted p-value, according to the following
%           rules:
%             * If p-value is NaN, return the character '-'.
%             * If p-value is more than 0.0005, it is formatted with three
%               decimal digits, otherwise it is formatted with scientific
%               notation (the final value will always have five 
%               characters).
%             * If p-value is between 0.01 and 0.05 it will be underlined.
%             * If p-value is less than 0.01 it will be double-underlined.
%
% See also LTXP.
% 
% Copyright (c) 2015 Nuno Fachada
% Distributed under the MIT License (See accompanying file LICENSE or copy 
% at http://opensource.org/licenses/MIT)
%

if isnan(pvalue)
    lvalue = '-';
else

    if pvalue > 0.0005
        lvalue = sprintf('%6.3f', pvalue);
    else
        lvalue = sprintf('\\num[output-exponent-marker=\\text{e}]{%5.0e}', ...
            pvalue);
    end;
    if pvalue < 0.01
        lvalue = sprintf('\\uuline{%s}', lvalue);
    elseif pvalue < 0.05
        lvalue = sprintf('\\uline{%s}', lvalue);
    end;

end;
