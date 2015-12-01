function stats = stats_gather(name, folder, files, num_outputs, ss_idx)
% STATS_GATHER Get statistical summaries (max, argmax, min, argmin, mean,
% std) taken from simulation outputs from multiple files.
%
%   stats = STATS_GATHER(name, folder, files, num_outputs, ss_idx)
%
% Parameters:
%        name - name with which to tag this data
%      folder - folder with files containing simulation output
%       files - files containing simulation output (use wildcards), each
%               file corresponds to an observation
% num_outputs - number of outputs in each file
%      ss_idx - iteration after which outputs are in steady-state (for mean
%               and std statistical summaries).
%
% Returns:
%     stats - a struct containing the fields 'name', containing the name
%             with which the data was tagged, and 'sdata', a n x m matrix, 
%             with n observations (from n files) and m statistical 
%             summaries (such that m = 6 * num_outputs, where 6 is the
%             number of statistical summaries).
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

% Put global stats matrix in output struct
stats = struct('name', name, 'sdata', sdata);
