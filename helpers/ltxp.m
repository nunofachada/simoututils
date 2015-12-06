function lvalue = ltxp(pvalue)
% LTXP Formats a p-value for LaTeX using the ltxpv function, setting minpv
% to 0.001 (i.e. truncating p-values to 0.001) and ulims to [0 0] (i.e.
% disabling underlines).
%
%   lvalue = LTXP(pvalue)
%
% Parameters:
%   value - P-value to format.
%
% Returns:
%  lvalue - A string with the formatted p-value.
%
% See also LTXPV.
%
% Copyright (c) 2015 Nuno Fachada
% Distributed under the MIT License (See accompanying file LICENSE or copy 
% at http://opensource.org/licenses/MIT)
%

lvalue = ltxpv(pvalue, 0.001, [0 0]);
