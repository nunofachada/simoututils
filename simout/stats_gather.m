function stats = stats_gather(name, folder, files, outputs, varargin)
% STATS_GATHER Get statistical summaries taken from simulation outputs from
% multiple files. The exact statistical summaries depend on the
% implementation of the stats_get function.
%
%   stats = STATS_GATHER(name, folder, files, outputs, varargin)
%
% Parameters:
%        name - Name with which to tag this data.
%      folder - Folder with files containing simulation output.
%       files - Files containing simulation output (use wildcards), each
%               file corresponds to an observation.
%     outputs - Either an integer representing the number of outputs in 
%               each file or a cell array of strings with the output names.
%               In the former case, output names will be 'o1', 'o2', etc.
%    varargin - Extra parameters for the stats_get function.
%
% Returns:
%     stats - A struct containing the following fields:
%              name - Contains the name with which the data was tagged.
%           outputs - Cell array containing the output names.
%           ssnames - A struct with two fields:
%                     text - Cell array of strings containing the names of 
%                            the statistical measures in plain text.
%                     latex - Cell array of strings containing the names of 
%                             the statistical measures in LaTeX format.
%             sdata - A n x m matrix, with n observations (from n files) 
%                     and m is the number of statistical summaries.
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

% Get names and number of statistical summaries
ssnames = stats_get();
ssnum = numel(ssnames.text);

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

% Throw error if no files were found
if numFiles == 0
    error('No files were found.');
end;

% Initialize stats
sdata = zeros(numFiles, num_outputs * ssnum);

% Read stats from files
for i = 1:numFiles
    
    % Read stats from current file into a m x n matrix where m corresponds
    % to number of statistical summaries and n to num_outputs.
    s = stats_get([folder '/' listing(i).name], num_outputs, varargin{:});
    
    % Reshape stats matrix into a vector and put it in global stats matrix.
    sdata(i, :) = reshape(s, 1, num_outputs * ssnum);
    
end;

% Put results in struct
stats = struct('name', name, 'outputs', {outputs}, ...
    'ssnames', ssnames, 'sdata', sdata);
