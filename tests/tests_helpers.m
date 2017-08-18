%
% Unit tests for SimOutUtils helper functions
%
% These tests require the MOxUnit framework available at
% https://github.com/MOxUnit/MOxUnit
%
% To run the tests: 
% 1 - Make sure MOxUnit is on the MATLAB/Octave path
% 2 - Make sure SimOutUtils is on the MATLAB/Octave path by running
%     startup.m
% 3 - cd into the tests folder
% 4 - Invoke the moxunit_runtests script
%
% Copyright (c) 2016-2017 Nuno Fachada
% Distributed under the MIT License (See accompanying file LICENSE or copy 
% at http://opensource.org/licenses/MIT)
%
function test_suite = tests_helpers
    try
        % assignment of 'localfunctions' is necessary in Matlab >= 2016
        test_functions = localfunctions();
    catch
        % no problem; early Matlab versions can use initTestSuite fine
    end;
    initTestSuite

function test_ci_t

    % Set RNG to a specific reproducible state
    if is_octave()
        rand('seed', 123);
    else
        rng(123, 'twister');
    end;
    
    % Some random data
    vecs = cell(3, 1);
    vecs{1} = randn(20, 1);
    vecs{2} = randn(200, 1) + 1;
    vecs{3} = randn(2000, 1) + 100;
    
    % Base alpha
    alpha = 0.05;
    
    % Get confidence intervals
    for i = 1:numel(vecs)
        ci = ci_t(vecs{i}, alpha);
        n = numel(vecs{i});
        s = std(vecs{i}) / sqrt(n);
        ci_loc = [mean(vecs{i}) - tinv(1 - alpha / 2, n - 1) * s, ...
            mean(vecs{i}) + tinv(1 - alpha / 2, n - 1) * s];
        assertElementsAlmostEqual(ci, ci_loc);
    end;
    

function test_ci_w

    % Set RNG to a specific reproducible state
    if is_octave()
        rand('seed', 321);
    else
        rng(321, 'twister');
    end;
    
    % Some random data
    vecs = cell(3, 1);
    vecs{1} = randn(20, 1);
    vecs{2} = randn(200, 1) + 1;
    vecs{3} = randn(2000, 1) + 100;
    
    % Base alpha
    alpha = 0.05;

    % G function for Willink CI
    G = @(r, a) ((1 + 6 * a * (r - a))^(1/3) - 1) / (2 * a);
    
    % Get confidence intervals
    for i = 1:numel(vecs)
        ci = ci_willink(vecs{i}, alpha);
        n = numel(vecs{i});
        s = std(vecs{i}) / sqrt(n);
        mvec = mean(vecs{i});
        mu3 = n * sum((vecs{i} - mvec).^3) / ((n - 1) * (n - 2));
        a = mu3 / (6 * sqrt(n) * var(vecs{i})^(3/2));
        ci_loc = [mvec - G(tinv(1 - alpha / 2, n - 1), a) * s, ...
            mvec - G(-tinv(1 - alpha / 2, n - 1), a) * s];
        assertElementsAlmostEqual(ci, ci_loc);
    end;

    
