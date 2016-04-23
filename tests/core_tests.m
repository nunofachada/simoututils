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
    
    % Keep the originally defined stats_get_* function
    original_stats_get = simoututils_stats_get_;
    
    % Set the stats_get_* function to stats_get_pphpc and test stats_get
    simoututils_stats_get_ = @stats_get_pphpc;
    
    % File to test
    file_to_test = ['..' filesep 'data' filesep 'pphpc' ...
        filesep 'nl_ok' filesep 'stats400v1r1.tsv'];
    
    % Load file into memory
    outs = dlmread(file_to_test);
    
    % Steady-state separator for stats_get_pphpc
    ss = 100;
    
    % Check if names of statistical summaries are well formed
    statnames = stats_get(100);
    assertTrue(all(isfield(statnames, {'text', 'latex'})));
    assertEqual(numel(getfield(statnames, 'text')), 6);
    assertEqual(numel(getfield(statnames, 'latex')), 6);
    
    %  Invoke stats_get which will call stats_get_pphpc
    sdata = stats_get(ss, file_to_test, 6);
    
    % Must be a numeric matrix of stats
    assertTrue(isnumeric(sdata));
    % Number of outputs is six
    assertEqual(size(sdata, 2), 6);
    % Number of stats is six
    assertEqual(size(sdata, 1), 6);
    
    % Check statistics for each output
    for i = 1:6
        
        % Get maximum and minimum
        [max_i, amax_i] = max(outs(:, i));
        [min_i, amin_i] = min(outs(:, i));
        
        % Maximum
        assertElementsAlmostEqual(max_i, sdata(1, i));
        % Arg. max. - We consider that iterations start at 0
        assertElementsAlmostEqual(amax_i - 1, sdata(2, i));
        % Minimum
        assertElementsAlmostEqual(min_i, sdata(3, i));
        % Arg. min. - We consider that iterations start at 0
        assertElementsAlmostEqual(amin_i - 1, sdata(4, i));
        % SS Mean
        assertElementsAlmostEqual(...
            mean(outs((ss + 1):size(outs, 1), i)), sdata(5, i));
        % SS Std.
        assertElementsAlmostEqual(...
            std(outs((ss + 1):size(outs, 1), i)), sdata(6, i));
    end;
    
    % Set the stats_get_* function to stats_get_iters and test stats_get
    simoututils_stats_get_ = @stats_get_iters;
    
    % Iterations specification for stats_get_iters
    iters = [0 10 100 175];
    niters = numel(iters);
    
    % Check if names of statistical summaries are well formed
    statnames = stats_get(iters);
    assertTrue(all(isfield(statnames, {'text', 'latex'})));
    assertEqual(numel(getfield(statnames, 'text')), niters);
    assertEqual(numel(getfield(statnames, 'latex')), niters);

    %  Invoke stats_get which will call stats_get_iters
    sdata = stats_get(iters, file_to_test, 6);
    
    % Must be a numeric matrix of stats
    assertTrue(isnumeric(sdata));
    % Number of outputs is six
    assertEqual(size(sdata, 2), 6);
    % Number of stats is niters
    assertEqual(size(sdata, 1), niters);
    
    % Check statistics for each output
    for i = 1:6
        
        % Check value for each iteration
        for j = 1:niters
            assertEqual(outs(iters(j) + 1, i), sdata(j, i));
        end;
        
    end;

    % Set originally defined stats_get_* function
    simoututils_stats_get_ = original_stats_get;
    
function test_stats_gather

    % Global specifying the defined stats_get_* function
    global simoututils_stats_get_;
   
    % Keep the originally defined stats_get_* function
    original_stats_get = simoututils_stats_get_;
    
    % Set the stats_get_* function to stats_get_pphpc and test stats_get
    simoututils_stats_get_ = @stats_get_pphpc;

    % Folder and files to load
    folder = '../data/pphpc/j_ex_ok';
    files = 'stats*.tsv';
    file_lst = dir([folder filesep files]);
    
    % Steady-state separator for stats_get_pphpc
    ss = 100;
    
    % Test specification of outputs as a number
    stats1 = stats_gather('Test1', folder, files, 6, ss);
    
    % Is returned value a struct?
    assertEqual(class(stats1), 'struct');
    
    % Does it contain the expected fields?
    assertTrue(all(isfield(stats1, ...
        {'name', 'outputs', 'ssnames', 'sdata'})));
    
    % Does it have the expected name?
    assertEqual(stats1.name, 'Test1');
    
    % Do outputs have the expected names?
    assertEqual(stats1.outputs, {'o1', 'o2', 'o3', 'o4', 'o5', 'o6'});
    
    % Does field ssnames have the expected fields?
    assertTrue(all(isfield(stats1.ssnames, {'text', 'latex'})));
    
    % Test specification of outputs as a cell array of names
    stats2 = stats_gather('Test2', folder, files, ...
        {'spop', 'wpop', 'gqty', 'sen', 'wen', 'gen'}, ss);
    
    % Is returned value a struct?
    assertEqual(class(stats2), 'struct');
    
    % Does it contain the expected fields?
    assertTrue(all(isfield(stats2, ...
        {'name', 'outputs', 'ssnames', 'sdata'})));
    
    % Does it have the expected name?
    assertEqual(stats2.name, 'Test2');
    
    % Do outputs have the expected names?
    assertEqual(stats2.outputs, ...
        {'spop', 'wpop', 'gqty', 'sen', 'wen', 'gen'});
    
    % Does field ssnames have the expected fields?
    assertTrue(all(isfield(stats2.ssnames, {'text', 'latex'})));
    
    % Is stats1.sdata the same as stats2.sdata?
    assertEqual(stats1.sdata, stats2.sdata);
    
    % Does the number of observations match the number of files?
    assertEqual(size(stats1.sdata, 1), numel(file_lst));
    
    % Are there 36 focal measures (6 outputs x 6 stats by stats_get_pphpc)
    assertEqual(size(stats1.sdata, 2), 36);
    
    % Get stats for each file and check if they are equal to the respective
    % row of stats1.sdata
    for i = 1:numel(file_lst)
        stats_obs1 = stats_get(ss, [folder filesep file_lst(i).name], 6);
        assertEqual(reshape(stats_obs1, 1, 36), stats1.sdata(i, :));
    end;
    
    % Set originally defined stats_get_* function
    simoututils_stats_get_ = original_stats_get;
 