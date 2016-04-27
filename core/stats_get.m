function sdata = stats_get(args, file, num_outputs)
% STATS_GET This is a facade function for stats_get_* functions. These
% functions extract statistical summaries from simulation outputs from one
% file. The exact stats_get_* function to use is defined in the
% simoututils_stats_get_ global variable.
%
%   stats = STATS_GET(args, file, num_outputs)
%
% Parameters:
%         args - Depends on the stats_get_* function defined in the
%                simoututils_stats_get_ global variable.
%        file  - File containing simulation outputs, columns correspond 
%                to outputs, rows correspond to iterations.
%  num_outputs - Number of outputs in file.
%
% Returns:
%       sdata - A n x num_outputs matrix, with n statistical summaries and
%               num_outputs outputs. If only the first argument is given, 
%               stats_get_* functions should return a struct with two 
%               fields:
%               text - Cell array of strings containing the names of the
%                      statistical measures in plain text.
%              latex - Cell array of strings containing the names of the
%                      statistical measures in LaTeX format.
%
% Notes:
%    The format of the data in each file is the following: columns 
%    correspond to outputs, rows correspond to iterations.
%
% Copyright (c) 2016 Nuno Fachada
% Distributed under the MIT License (See accompanying file LICENSE or copy 
% at http://opensource.org/licenses/MIT)
%

% The actual function to use is set in the following global variable
global simoututils_stats_get_;

% How many arguments were passed?
if nargin == 1
    % Return names of statistical summaries.
    sdata = simoututils_stats_get_(args);
else
    % Return matrix of statistical summaries.
    sdata = simoututils_stats_get_(args, file, num_outputs);
end;