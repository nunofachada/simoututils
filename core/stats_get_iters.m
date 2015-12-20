function sdata = stats_get_iters(args, file, num_outputs)
% STATS_GET_ITERS Obtain statistical summaries corresponding to output 
% values at user-specified iterations from simulation outputs given in a 
% file.
%
%   stats = STATS_GET_ITERS(args, file, num_outputs)
%
% Parameters:
%       args  - Vector of iterations at which simulation outputs are
%               measured.       
%       file  - File containing simulation outputs, columns correspond to 
%               outputs, rows correspond to iterations.
% num_outputs - Number of outputs in file.
%
% Returns:
%       sdata - A n x num_outputs matrix, with n statistical summaries and
%               num_outputs outputs. If no arguments are given, this
%               function returns a struct with two fields:
%               text - Cell array of strings containing the names of the
%                      statistical measures in plain text.
%              latex - Cell array of strings containing the names of the
%                      statistical measures in LaTeX format.
%
% Copyright (c) 2015 Nuno Fachada
% Distributed under the MIT License (See accompanying file LICENSE or copy 
% at http://opensource.org/licenses/MIT)
%

% How many statistical summaries?
nssumms = numel(args);

% If only the first argument is given...
if nargin == 1
    % ...return names of statistic summaries
    sdata = struct('text', {cell(1, nssumms)}, ...
        'latex', {cell(1, nssumms)});
    for i = 1:nssumms
        sdata.text{i} = ['i' num2str(args(i))];
        sdata.latex{i} = ['i' num2str(args(i))];
    end;
    return;
end;

% Read stats file
data = dlmread(file);

% Initialize stats matrix
sdata = zeros(nssumms, num_outputs);

% Determine stats for each of the outputs
for i = 1:num_outputs
    
    % Cycle through statistical summaries
    for j = 1:nssumms
        
        % Iterations start at zero, but Matlab starts indexing at 1, so we
        % have to add 1.
        sdata(j, i) = data(args(j) + 1, i);
        
    end;
     
end;