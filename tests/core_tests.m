%
% Unit tests for SimOutUtils core functions
%
% These tests require the MOxUnit framework available at
% https://github.com/MOxUnit/MOxUnit
%    
% Copyright (c) 2016 Nuno Fachada
% Distributed under the MIT License (See accompanying file LICENSE or copy 
% at http://opensource.org/licenses/MIT)
%
function test_suite = core_tests
    initTestSuite

function test_stats_get_

    % Global specifying the defined stats_get_* function
    global simoututils_stats_get_;
    
    % File to test
    file_to_test = ['..' filesep 'data' filesep 'pphpc' ...
        filesep 'nl_ok' filesep 'stats400v1r1.tsv'];
    
    % Keep the originally defined stats_get_* function
    original_stats_get = simoututils_stats_get_;

    % Set the stats_get_* function to stats_get_pphpc and test stats_get
    simoututils_stats_get_ = @stats_get_pphpc;
    
    %  Invoke stats_get which will call stats_get_pphpc
    sdata = stats_get(100, file_to_test, 6);
    
    % Must be a numeric matrix of stats
    assertTrue(isnumeric(sdata));
    % Number of outputs is six
    assertEqual(size(sdata, 2), 6);
    % Number of stats is six
    assertEqual(size(sdata, 1), 6);
    
    % Set the stats_get_* function to stats_get_iters and test stats_get
    simoututils_stats_get_ = @stats_get_iters;

    %  Invoke stats_get which will call stats_get_iters
    sdata = stats_get([10 100 175], file_to_test, 6);
    
    % Must be a numeric matrix of stats
    assertTrue(isnumeric(sdata));
    % Number of outputs is six
    assertEqual(size(sdata, 2), 6);
    % Number of stats is three
    assertEqual(size(sdata, 1), 3);

    % Set originally defined stats_get_* function
    simoututils_stats_get_ = original_stats_get;
    
    