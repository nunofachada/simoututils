function t = stats_compare_table(tests, pthresh, tformat, varargin)
% STATS_COMPARE_TABLE To do.
%
%   t = STATS_COMPARE_TABLE(tests, alpha, what, format, varargin)
%
% Parameters:
%    tests - To decide. Most likely will be 'p' and 'np'. Specific test is
%            then chosen depending on the number of samples (2 or >2).
%  pthresh - Minimum value of p-value before truncation.
%  tformat - Landscape or portrait.
% varargin - Stuff from stats_compare.
%
% Outputs:
%        t - LaTeX table. Do a plain text one?
%
% Copyright (c) 2015 Nuno Fachada
% Distributed under the MIT License (See accompanying file LICENSE or copy 
% at http://opensource.org/licenses/MIT)
%



