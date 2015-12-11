function [m, v, cit, ciw, sw, sk] = stats_analyze(data, alpha)
% STATS_ANALYZE Analyze statistical summaries taken from simulation output.
%
%   [m, v, cit, ciw, sw, sk] = STATS_ANALYZE(data, alpha)
%
% Parameters:
%  data - Data to analyze, n x m matrix, n observations, m statistical
%         summaries.
% alpha - Significance level for confidence intervals and Shapiro-Wilk
%         test.
%
% Returns:
%     m - Vector of m means.
%     v - Vector of m variances.
%   cit - m x 2 matrix of t-confidence intervals.
%   ciw - m x 2 matrix of Willink confidence intervals.
%    sw - Vector of m p-values of the Shappiro-Wilk test.
%    sk - Vector of m skewnesses.
% 
% Copyright (c) 2015 Nuno Fachada
% Distributed under the MIT License (See accompanying file LICENSE or copy 
% at http://opensource.org/licenses/MIT)
%

% How many statistical summaries?
nssumms = size(data, 2);

% Allocate space for function outputs
m = zeros(nssumms, 1);
v = zeros(nssumms, 1);
cit = zeros(nssumms, 2);
ciw = zeros(nssumms, 2);
sw = zeros(nssumms, 1);
sk = zeros(nssumms, 1);

% Cycle through statistical summaries
for i = 1:nssumms
    
    % Get all observations for current statistical summary
    cdat = data(:, i);
    
    % Find mean, variance and skewness
    m(i) = mean(cdat);
    v(i) = var(cdat);
    sk(i) = skewness(cdat);
    
    % If variance is not zero...
    if v(i) > 0
        
        % ...determine confidence intervals...
        cit(i, :) = ci_t(cdat, alpha);
        ciw(i, :) = ci_willink(cdat, alpha);
        % ...and perform the Shapiro-Wilk normality test.
        [~, sw(i)] = swtest(cdat);
    
    else
        
        % ...otherwise 
        cit(i, :) = [m(i) m(i)];
        ciw(i, :) = [m(i) m(i)];
        sw(i) = NaN;
    
    end;
   
end;