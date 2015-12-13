function sdata = stats_get(args, file, num_outputs)
% STATS_GET Facade function for stats_get_* functions.
%
%   stats = STATS_GET(file, num_outputs, varargin)
%
% Parameters:
%        args - Depends on the stats_get_* implementation.
%       file  - File containing simulation outputs, columns correspond to 
%               outputs, rows correspond to iterations.
% num_outputs - Number of outputs in file.
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
%
% Copyright (c) 2015 Nuno Fachada
% Distributed under the MIT License (See accompanying file LICENSE or copy 
% at http://opensource.org/licenses/MIT)
%

% Actual function to use - Edit this line to use another function
sgfun = @stats_get_pphpc;

% How many arguments were passed?
if nargin == 1
    % Return names of statistical summaries.
    sdata = sgfun(args);
else
    % Return matrix of statistical summaries.
    sdata = sgfun(args, file, num_outputs);
end;