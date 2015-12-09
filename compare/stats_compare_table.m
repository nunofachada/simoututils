function t = stats_compare_table(tests, pthresh, tformat, varargin)
% STATS_COMPARE_TABLE Output a LaTeX table with p-values resulting from
% statistical tests used to evaluate the alignment of model implementations.
%
%   t = STATS_COMPARE_TABLE(tests, pthresh, tformat, varargin)
%
% Parameters:
%    tests - Either 'p' or 'np', for parametric or non-parametric tests,
%            respectively. The parametric tests are the t-test and ANOVA
%            when comparing two or more models, respectively. The
%            non-parametric tests are Mann-Whitney or Kruskal-Wallis when
%            comparing two or more models, respectively. Can also be a 
%            cell array of strings, each string corresponding to the test 
%            to apply to each of the six statistical summaries, namely max, 
%            argmax, min, argmin, ss-mean and ss-std. For example, 
%            {'p', 'np', 'p', 'np', 'p', 'p'} will apply a parametric test
%            to all summaries except argmax and argmin, to which a
%            non-parametric test is applied instead.
%  pthresh - Minimum value of p-values before truncation.
%  tformat - Either 0 or 1. If 0, output names are placed in the table
%            header (better for fewer comparisons). If 1, output names are
%            placed in the first column (better for more comparisons).
% varargin - Variable number of cell arrays containing the following two
%            items defining a comparison:
%            1 - Either: a) a string describing the comparison name; b) a 
%                cell array of two strings, the first describing a 
%                comparison group name, and the second describing a 
%                comparison name; or, c) zero, 0, an indication not to 
%                print any type of comparison name.
%            2 - A cell array of statistical summaries (given by the 
%                stats_gather function) of the implementations to be 
%                compared.
%
% Outputs:
%        t - LaTeX table.
%
% Copyright (c) 2015 Nuno Fachada
% Distributed under the MIT License (See accompanying file LICENSE or copy 
% at http://opensource.org/licenses/MIT)
%

% How many comparisons?
ncomps = nargin - 3;
if ncomps < 1
    error('At least one comparison must be specified.');
end;

% Perform statistical comparison
cmp_pvals = cell(1, ncomps);
for i = 1:ncomps
    cmp_pvals{i} = stats_compare(0.01, tests, varargin{i}{2}{:});
end;

% Comparison grouping and names
if isnumeric(varargin{1}{1})
    
    % No comparison group or comparison names
    cmplvl = 0;
    
elseif ischar(varargin{1}{1})
    
    % Print comparison names
    cmplvl = 1;
    
elseif iscellstr(varargin{1}{1})
    
    % Print comparison group names and comparison names
    cmplvl = 2;
    
    % Determine how many comparison groups there are (assume comparisons of
    % the same group are given sequentially), and count how many comparison 
    % each group contains
    ngrps = 1;
    grps(1).name = varargin{1}{1}{1};
    grps(1).ncomps = 1;
    for i = 2:(nargin - 3)
        if strcmp(varargin{i}{1}{1}, varargin{i - 1}{1}{1})
            grps(ngrps).ncomps = grps(ngrps).ncomps + 1;
        else
            ngrps = ngrps + 1;
            grps(ngrps).name = varargin{i}{1}{1};
            grps(ngrps).ncomps = 1;
        end;
    end;

else
    error('Invalid argument.');
end;

% Names of statistical summaries 
ssumms = {'$\max$', '$\argmax$', '$\min$', '$\argmin$', ...
                '$\mean{X}^{\text{ss}}$', '$S^{\text{ss}}$'};
            
% Determine number of outputs and output names
outputs = varargin{1}{2}{1}.outputs;
nout = numel(outputs);

% First part of table
t = '\begin{tabular}{';

% What is the table format?
if tformat == 0 % Output names in the header

    % Columns for comparison group name and comparison name
    t = sprintf('%s%s', t, repmat('c', 1, cmplvl));
    
    % Close begin tabular for the specified number of outpus, and add a
    % top rule.
    t = sprintf('%sl%s}\n', t, repmat('r', 1, nout));
    t = sprintf('%s\\toprule\n', t);
    
    % Comparison group and comparison name
    if cmplvl == 2, t = sprintf('%s\\multirow{2}{*}{Group.} & ', t); end;
    if cmplvl >= 1, t = sprintf('%s\\multirow{2}{*}{Comp.} & ', t); end;
    
    % Finalize header
    t = sprintf('%s\\multirow{2}{*}{Stat.} & ', t);
    t = sprintf('%s\\multicolumn{%d}{c}{Outputs} \\\\\n', t, nout);
    t = sprintf('%s\\cmidrule(l){%d-%d}\n', t, ...
        2 + cmplvl, 1 + cmplvl + nout);
    t = sprintf('%s%s', t, repmat(' &', 1, cmplvl));
    for i = 1:nout
        t = sprintf('%s & %s', t, outputs{i});
    end;
    t = sprintf('%s \\\\\n', t);
    
    % Current group
    g = 1;
        
    % Cycle through comparisons
    for i = 1:ncomps
        
        if cmplvl == 2
            
            print_comp_name = false;
            
            % Is current comparison in a new group?
            if i > 1
                if ~strcmp(varargin{i}{1}{1}, varargin{i - 1}{1}{1})
                    
                    % Update group index
                    g = g + 1;
                    print_comp_name = true;

                end;
            else
                print_comp_name = true;
            end;
             Close
            % Print a midrule
            if (i == 1) || print_comp_name
                t = sprintf('%s\\midrule\n', t);
            else
                t = sprintf('%s\\cmidrule(l){2-%d}\n', t, 3 + nout);
            end;
             
            % Print comparison group name
            if print_comp_name
                t = sprintf('%s\\multirow{%d}{*}{%s}', ...
                    t, 6 * grps(g).ncomps, varargin{i}{1}{1}); 
            end;
            
            % Comparison name
            t = sprintf('%s & \\multirow{6}{*}{%s} & \n', ...
                t, varargin{i}{1}{2}); 
            
        elseif cmplvl == 1
            
            % Print a midrule Close
            t = sprintf('%s\\midrule\n', t);

            % Comparison name
            t = sprintf('%s\\multirow{6}{*}{%s} & \n', t, varargin{i}{1});

        else
            
            % Print a midrule
            t = sprintf('%s\\midrule\n', t);
            
        end;
        
        % Cycle through statistical summaries
        for j = 1:6
            
            % Space for comparison and comparison group names
            if j > 1, t = sprintf('%s%s', t, repmat('& ', 1, cmplvl)); end;
            
            % Print statistical summary name
            t = sprintf('%s%s', t, ssumms{j});
            
            % Cycle through outputs
            for k = 1:nout
                
                % Print p-value for current focal measure
                t = sprintf('%s & %s', ...
                    t, ltxpv(cmp_pvals{i}(k, j), pthresh));
                
            end;
            
            % Next line
            t = sprintf('%s\\\\\n', t);
            
        end;
        
    end;
    
elseif tformat == 1 % Output names in the first column
    
    % Close begin tabular for the specified number of comparisons, and add
    % a top rule.
    t = sprintf('%scl%s}\n', t, repmat('r', 1, ncomps));
    t = sprintf('%s\\toprule\n', t);
    
    % Print header
    if cmplvl == 0
        t = sprintf('%sOut. & ', t);
        t = sprintf('%sStat.', t);
        t = sprintf('%s & \\multicolumn{%d}{c}{\\emph{p}-values}', ...
            t, ncomps);
    elseif cmplvl == 1
        t = sprintf('%s\\multirow{2}{*}{Out.} & ', t);
        t = sprintf('%s\\multirow{2}{*}{Stat.}', t);
        t = sprintf('%s & \\multicolumn{%d}{c}{Comparisons}', t, ncomps);
        t = sprintf('%s\\\\\n\\cmidrule(r){3-%d}\n &', t, 2 + ncomps);
        for i = 1:ncomps
            t = sprintf('%s & \\multicolumn{1}{c}{%s}', t, varargin{i}{1});
        end;
    elseif cmplvl == 2
        t = sprintf('%s\\multirow{2}{*}{Out.} & ', t);
        t = sprintf('%s\\multirow{2}{*}{Stat.}', t);
        for i = 1:ngrps
            t = sprintf('%s & \\multicolumn{%d}{c}{%s}', ...
                t, grps(i).ncomps, grps(i).name);
        end;
        t = sprintf('%s\\\\\n', t);
        % cmidrules
        sumcmps = 0;
        for i = 1:ngrps
            t = sprintf('%s\\cmidrule(r){%d-%d} ', t, ...
                3 + sumcmps, 2 + sumcmps + grps(i).ncomps);
            sumcmps = sumcmps + grps(i).ncomps;
        end;
        t = sprintf('%s\n & ', t);
        for i = 1:ncomps
            t = sprintf('%s & \\multicolumn{1}{c}{%s}', ...
                t, varargin{i}{1}{2});
        end;
    end;
    t = sprintf('%s\\\\\n', t);
    
    % Print p-values
    for i = 1:nout
        t = sprintf('%s\\midrule\n', t);
        t = sprintf('%s\\multirow{6}{*}{%s}', t, outputs{i});
        for j = 1:6
            t = sprintf('%s & %s', t, ssumms{j});
            for k = 1:ncomps

                % Print p-value for current focal measure
                t = sprintf('%s & %s', ...
                    t, ltxpv(cmp_pvals{k}(i, j), pthresh));
                
            end;
            t = sprintf('%s\\\\\n', t);
        end;
    end;
    
    
else % Unknown table format.
    
    error('Unknown table format.');
    
end;

% Last part of table
t = sprintf('%s\\bottomrule\n', t);
t = sprintf('%s\\end{tabular}\n', t);