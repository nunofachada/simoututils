function lvalue = ltxp(pvalue, minpv)
% LTXP Formats a p-value for LaTeX, value less than minpv are formatted to
% "< minpv" (requires LaTeX siunitx package).
%
%   lvalue = LTXP(value)
%
% Parameters:
%   value - P-value to format.
%   minpv - Minimum displayable value (optional, default = 0.001).
%
% Returns:
%  lvalue - A string with the formatted p-value, according to the following
%           rules:
%             * If p-value is less than minpv, return "< minpv" (e.g. 
%               "< 0.001" for minpv = 0.001).
%             * Otherwise use ltxr function for formatting.
%
% See also LTXR, LTXPE.
% 
% Copyright (c) 2015 Nuno Fachada
% Distributed under the MIT License (See accompanying file LICENSE or copy 
% at http://opensource.org/licenses/MIT)
%

% Default minpv
if nargin == 1
    minpv = 0.001;
end;

% This prevents printing zero for very low pvalues
if pvalue < minpv
    pvalue = minpv / 2;
end;

if pvalue < minpv
    lvalue = sprintf('\\num[round-mode=places,round-minimum=%f]{%f}', ...
        minpv, pvalue);
else
    lvalue = ltxr(pvalue);
end;

