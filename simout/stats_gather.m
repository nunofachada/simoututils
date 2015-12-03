function stats = stats_gather(name, folder, files, outputs, ss_idx)
% STATS_GATHER Get statistical summaries (max, argmax, min, argmin, mean,
% std) taken from simulation outputs from multiple files.
%
%   stats = STATS_GATHER(name, folder, files, outputs, ss_idx)
%
% Parameters:
%        name - Name with which to tag this data.
%      folder - Folder with files containing simulation output.
%       files - Files containing simulation output (use wildcards), each
%               file corresponds to an observation.
%     outputs - Either an integer representing the number of outputs in 
%               each file or a cell array of strings with the output names.
%               In the former case, output names will be 'o1', 'o2', etc.
%      ss_idx - Iteration after which outputs are in steady-state (for mean
%               and std statistical summaries).
%
% Returns:
%     stats - A struct containing the following fields:
%              name - Contains the name with which the data was tagged.
%           outputs - Cell array containing the output names.
%             sdata - A n x m matrix, with n observations (from n files) 
%                     and m focal measures (such that m = 6 * number of 
%                     outputs, where 6 is the number of statistical 
%                     summaries).
%
% Details:
%   The format of the data in each file is the following: columns 
%   correspond to outputs, while rows correspond to iterations.
%
% See also STATS_GET.
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

% Get file list
listing = dir([folder '/' files]);

% How many files?
numFiles = size(listing, 1);

% Initialize stats
sdata = zeros(numFiles, num_outputs * 6);

% Read stats from files
for i = 1:numFiles
    
    % Read stats from current file into a m x n matrix where m corresponds
    % to stats and n to num_outputs.
    s = stats_get([folder '/' listing(i).name], num_outputs, ss_idx);
    
    % Reshape stats matrix into a vector and put it in global stats matrix
    sdata(i,:) = reshape(s, 1, num_outputs * 6);
    
end;

% Put results in struct
stats = struct('name', name, 'outputs', {outputs}, 'sdata', sdata);
