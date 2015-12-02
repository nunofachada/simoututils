function tqq = tikqq(qq, markprop, lineprop)
% TIKQQ Creates a QQ-plot in TikZ.
%
%   tqq = TIKQQ(x, markprop, lineprop)
%
% Parameters:
%         x - A struct with the following fields (as returned by the qqcalc 
%             function):
%              xx - Horizontal coordinates of the QQ-plot points.
%              yy - Vertical coordinates of the QQ-plot points.
%             lxx - Horizontal coordinates of the x=y line.
%             lyy - Vertical coordinates of the x=y line.
%  markprop - Mark properties (optional, 
%             default = 'mark=*,mark size=0.4pt').
%  lineprop - Line (x=y) properties (optional, default = 'black!30').
%
%
% Returns:
%     tqq - A string containing the LaTeX/TikZ code to draw the QQ-plot.
%
% See also QQCALC.
% 
% Copyright (c) 2015 Nuno Fachada
% Distributed under the MIT License (See accompanying file LICENSE or copy 
% at http://opensource.org/licenses/MIT)
%

% Check if mark and line properties are given as parameters, if not set
% default values.
if nargin < 2
    markprop = 'mark=*,mark size=0.4pt';
end;
if nargin < 3
    lineprop = 'black!30';
end;

% Begin TikZ picture and set normalized drawing area
tqq = '\begin{tikzpicture} \path (-1,-1) (1,1);';

% Draw x=y line
tqq = sprintf(['%s \\draw[%s] plot coordinates ' ...
    '{(%5.3f,%5.3f) (%5.3f,%5.3f)};'], ...
    tqq, lineprop, qq.lxx(1), qq.lyy(1), qq.lxx(2), qq.lyy(2));

% Begin drawing points in QQ-plot
tqq = sprintf('%s \\path plot[%s] coordinates {', tqq, markprop);

% Draw individual points
for i=1:numel(qq.xx)
    tqq = sprintf('%s (%5.3f,%5.3f)', tqq, qq.xx(i), qq.yy(i));
end;

% End drawing points in QQ-plot
tqq = sprintf('%s};', tqq);

% End TikZ picture
tqq = sprintf('%s \\end{tikzpicture} ', tqq);