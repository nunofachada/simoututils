function tkh = tikhist(hst, hmul, lwidth)
% TIKHIST Creates an histogram in TikZ.
%
%   tkh = TIKHIST(hst, hmul, lwidth)
%
% Parameters:
%     hst - Vector of histogram heights.
%    hmul - Height scaling, numeric (optional, default = 5).
%  lwidth - Line width, string (optional, default = '4pt').
%
% Returns:
%     tkh - A string representing the TikZ figure histogram.
% 
% Copyright (c) 2015 Nuno Fachada
% Distributed under the MIT License (See accompanying file LICENSE or copy 
% at http://opensource.org/licenses/MIT)
%

% Check if hmul and lwidth arguments are given by the user, if not set
% default values.
if nargin < 3
    lwidth = '4pt';
end;
if nargin < 2
    hmul = 5;
end;

% Normalize heights
hst = hst * hmul / max(hst);

% Begin TikZ picture
tkh = '\begin{tikzpicture}';

% Start histogram
tkh = sprintf('%s \\draw[line width=%s] plot coordinates {(0,0) (1,0)', ...
    tkh, lwidth);

% Cycle through histogram heights and draw them
for i=1:numel(hst);
    tkh = sprintf('%s (%d,%4.2f) (%d,%4.2f)', tkh, i, hst(i), ...
        i + 1, hst(i));
end;

% Finish histogram and end TikZ picture
tkh = sprintf('%s (%d,0) (%d,0)}; \\end{tikzpicture} ', ...
    tkh, numel(hst) + 1, numel(hst) + 2);

