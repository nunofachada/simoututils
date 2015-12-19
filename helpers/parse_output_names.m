function [outputs, num_outputs] = parse_output_names(outputs)
% PARSE_OUTPUT_NAMES Determine effective output names and number of 
% outputs.
%
%   [outputs, num_outputs] = PARSE_OUTPUT_NAMES(outputs)
%
% Parameters:
%     outputs - Either an integer representing the number of outputs in 
%               each file or a cell array of strings with the output names.
%               In the former case, output names will be 'o1', 'o2', etc.
%
% Outputs:
%     outputs - Effective output names.
% num_outputs - Number of outputs.
%
% Copyright (c) 2015 Nuno Fachada
% Distributed under the MIT License (See accompanying file LICENSE or copy 
% at http://opensource.org/licenses/MIT)
%

% Determine the type of the 'outputs' argument
if iscellstr(outputs)
    
    % It's a cell array of strings, determine the number of outputs and
    % keep this value in the num_outputs variable.
    num_outputs = numel(outputs);
    
elseif isnumeric(outputs) && numel(outputs) == 1 && outputs >= 1
    
    % It's an integer, move number of outputs to the num_outputs variable
    % and set default output names.
    num_outputs = round(outputs);
    outputs = cell(1, num_outputs);
    for i = 1:num_outputs
        outputs{i} = ['o' num2str(i)];
    end;
    
else
    
    % Invalid type, throw error.
    error(['The "outputs" argument must be an integer or a cell array' ...
        ' of strings']);
    
end;