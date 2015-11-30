function e = hist_edges(vec, maxbins)
% HIST_EDGES Finds the edges for an histogram.
%
%   e = HIST_EDGES(vec, maxbins)
%
% Parameters:
%     vec - Vector with data.
% maxbins - Maximum number of histogram bins (optional, default value =
%           10).
%
% Returns:
%       e - Vector of histogram edges.
% 
% Description:
%     This is a helper function used for plotting histograms in LaTeX/TikZ.
%
% Copyright (c) 2015 Nuno Fachada
% Distributed under the MIT License (See accompanying file LICENSE or copy 
% at http://opensource.org/licenses/MIT)
%

if nargin == 1
    maxbins = 10;
end;

bins = min(maxbins, max(numel(unique(vec)), 2) - 1);
inc = (max(vec) - min(vec)) / bins;
if inc == 0
    inc = 1;
end;
e = min(vec):inc:max(vec);

