%
% Unit tests for SimOutUtils compare functions
%
% These tests require the MOxUnit framework available at
% https://github.com/MOxUnit/MOxUnit
%    
% Copyright (c) 2016 Nuno Fachada
% Distributed under the MIT License (See accompanying file LICENSE or copy 
% at http://opensource.org/licenses/MIT)
%
function test_suite = compare_tests
    initTestSuite


% Test stats_compare function
function test_stats_compare

    % Global specifying the defined stats_get_* function
    global simoututils_stats_get_;
    
    % Keep the originally defined stats_get_* function
    original_stats_get = simoututils_stats_get_;
    
    % Set the stats_get_* function to stats_get_pphpc and test stats_get
    simoututils_stats_get_ = @stats_get_pphpc;
    
    % Function which returns true if value is between 0 and 1
    b01 = @(x) (x <= 1) .* (x >= 0);

    %
    % Perform comparison using included test data
    %

    % Load test data
    snl_ok = stats_gather('NL_OK', ...
        '../data/pphpc/nl_ok', 'stats400v1*.tsv', 6, 100);
    sjex_ok = stats_gather('JEX_OK', ...
        '../data/pphpc/j_ex_ok', 'stats400v1*.tsv', 6, 100);
    sjex_ns = stats_gather('JEX_NS', ...
        '../data/pphpc/j_ex_noshuff', 'stats400v1*.tsv', 6, 100);
    sjex_diff = stats_gather('JEX_DIFF', ...
        '../data/pphpc/j_ex_diff', 'stats400v1*.tsv', 6, 100);
    sall = {snl_ok, sjex_ok, sjex_ns, sjex_diff};
    
    % Different specs to experiment with
    stests = {'p', 'np', {'p', 'np'}, {'p', 'np', 'p', 'np', 'p', 'p'}};
    padjst = {'holm', 'hochberg', 'hommel', 'bonferroni', 'BH', 'BY', ...
        'sidak', 'none'};
    alphas = [0.01 0.05];
    
    % Compare all with all with different test specifications
    for i = 1:numel(sall)
        for j = 1:numel(sall)
            for k = 1:numel(padjst)
                for l = 1:numel(stests)
                    for m = 1:numel(alphas)
                        % Perform comparison
                        [ps, h_all] = stats_compare(alphas(m), ...
                            stests{l}, padjst(k), sall{i}, sall{j});
                        % Check if results are as expected
                        assertTrue(all(all(b01(ps))));
                        assertEqual(size(ps), [6 6]);
                        assertEqual(numel(h_all), 1);
                    end;
                end;
            end;
        end;
    end;
    
    %
    % Perform comparison with artificially created stats_gather data
    %

    alpha = 0.01;
    nobs = 20;
    nouts = 5;
    nss = 2;
    nfms = nouts * nss;
    
    % Set RNG to a specific reproducible state
    if is_octave()
        rand('seed', 56789);
    else
        rng(56789, 'twister');
    end;
  
    % Create bogus stats_gather data with 20 observations and 10 FMs
    % (5 outputs, 2 statistical measures)
    sg1 =  struct('name', 'sg1', 'sdata', randn(nobs, nfms), ...
        'outputs', {{'o1','o2','o3','o4','o5'}}, ...
        'ssnames', ...
        struct('text', {{'fm1','fm2'}}, 'latex', {{'fm1','fm2'}}));
    sg2 =  struct('name', 'sg2', 'sdata', randn(nobs, nfms), ...
        'outputs', {{'o1','o2','o3','o4','o5'}}, ...
        'ssnames', ...
        struct('text', {{'fm1','fm2'}}, 'latex', {{'fm1','fm2'}}));
    sg3 =  struct('name', 'sg3', 'sdata', randn(nobs, nfms), ...
        'outputs', {{'o1','o2','o3','o4','o5'}}, ...
        'ssnames', ...
        struct('text', {{'fm1','fm2'}}, 'latex', {{'fm1','fm2'}}));
    
    inames = {sg1.name, sg2.name, sg3.name};
    
    %%%% 1. Compare two bogus objects using parametric tests
    [ps, h_all] = stats_compare(alpha, 'p', 'none', sg1, sg2);

    % Unroll result into a vector of FM p-values instead of a matrix
    pvals = reshape(ps', nfms, 1);
    
    % Failed tests
    failed = 0;
    
    % Check if test results are as expected
    for i = 1:nfms
        
        % Get t-test p-value for current FM
        if is_octave()
            p = t_test_2(sg1.sdata(:, i), sg2.sdata(:, i));
        else
            [~, p] = ttest2(sg1.sdata(:, i), sg2.sdata(:, i));
        end;
        
        % Check if p-value is what is expected
        assertElementsAlmostEqual(pvals(i), p);
        
        % Update number of failed tests
        if p < alpha, failed = failed + 1; end;
        
    end;
    
    % Check if number of failed tests is as expected
    assertEqual(h_all, failed);
   
    
    %%%% 2. Compare three bogus objects using parametric tests
    [ps, h_all] = stats_compare(alpha, 'p', 'none', sg1, sg2, sg3);

    % Unroll result into a vector of FM p-values instead of a matrix
    pvals = reshape(ps', nfms, 1);
    
    % Failed tests
    failed = 0;
    
    % Check if test results are as expected
    for i = 1:nfms
        
        % Matrix with 3 groups (one group per column)
        data = [sg1.sdata(:, i) sg2.sdata(:, i) sg3.sdata(:, i)];
        
        % Get ANOVA p-value for current FM
        if is_octave()
            p = anova(data);
        else
            p = anova1(data, inames, 'off');
        end;
        
        % Check if p-value is what is expected
        assertElementsAlmostEqual(pvals(i), p);
        
        % Update number of failed tests
        if p < alpha, failed = failed + 1; end;
        
    end;
    
    % Check if number of failed tests is as expected
    assertEqual(h_all, failed);
   
    
    %%%% 3. Compare two bogus objects using non-parametric tests
    [ps, h_all] = stats_compare(alpha, 'np', 'none', sg1, sg2);

    % Unroll result into a vector of FM p-values instead of a matrix
    pvals = reshape(ps', nfms, 1);
    
    % Failed tests
    failed = 0;
    
    % Check if test results are as expected
    for i = 1:nfms
        
        % Get Mann-Whitney p-value for current FM
        if is_octave()
            p = u_test(sg1.sdata(:, i), sg2.sdata(:, i));
        else
            p = ranksum(sg1.sdata(:, i), sg2.sdata(:, i));
        end;        
        
        % Check if p-value is what is expected
        assertElementsAlmostEqual(pvals(i), p);
        
        % Update number of failed tests
        if p < alpha, failed = failed + 1; end;
        
    end;
    
    % Check if number of failed tests is as expected
    assertEqual(h_all, failed);
   
    
    %%%% 4. Compare three bogus objects using non-parametric tests
    [ps, h_all] = stats_compare(alpha, 'np', 'none', sg1, sg2, sg3);

    % Unroll result into a vector of FM p-values instead of a matrix
    pvals = reshape(ps', nfms, 1);
    
    % Failed tests
    failed = 0;
    
    % Check if test results are as expected
    for i = 1:nfms
        
        % Matrix with 3 groups (one group per column)
        data = [sg1.sdata(:, i) sg2.sdata(:, i) sg3.sdata(:, i)];
        
        % Get Kruskal-Wallis p-value for current FM
        if is_octave()
            cdata = num2cell(data, 1);
            p = kruskal_wallis_test(cdata{:});
        else
            p = kruskalwallis(data, inames, 'off');
        end;
        
        % Check if p-value is what is expected
        assertElementsAlmostEqual(pvals(i), p);
        
        % Update number of failed tests
        if p < alpha, failed = failed + 1; end;
        
    end;
    
    % Check if number of failed tests is as expected
    assertEqual(h_all, failed);
   
    
    % Set originally defined stats_get_* function
    simoututils_stats_get_ = original_stats_get;

  