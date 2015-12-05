## Comparison of multiple model implementations

### File format

The simulation output file format is the same as in the case of the
[distributional analysis of simulation output](../simout), i.e. TSV 
(tab-separated values), one column per output, one row per iteration.

### Octave compatibility

These utilities are compatible with GNU Octave. However, note that a number of 
statistical test functions provided by Octave return slightly different 
_p_-values from those returned by the equivalent MATLAB functions. 

### Utilities

* [stats_compare](stats_compare.m) - Compare focal measures from two model 
implementations by applying the specified statistical tests.

* [stats_compare_many_pw](stats_compare_many_pw.m) Compare focal measures from
multiple model implementations, pair-wise, by applying the specified statistical 
tests. This function outputs a plain text table of pair-wise failed tests.

### Examples

These examples use the datasets available at 
[![DOI](https://zenodo.org/badge/doi/10.5281/zenodo.34049.svg)](http://dx.doi.org/10.5281/zenodo.34049).
Unpack the datasets to any folder and put the complete path to this 
folder in variable `datafolder`, e.g.:

```matlab
datafolder = 'path/to/datasets';
```

These datasets correspond to the results presented in the manuscript
[Parallelization Strategies for Spatial Agent-Based Models](http://arxiv.org/abs/1507.04047).

#### Example 1: Compare focal measures of the NetLogo and Java EX implementations of the PPHPC model

Perform comparison using 10 replications of each implementation with model size
400, parameter set 1. Replications of the Java EX variant were performed with 12
threads. For the [stats_gather](stats_gather.m) function:

* The third parameter, 6, corresponds to the number of model outputs. 
Alternatively, a cell array of strings containing the output names could have
been used.
* The fourth parameter, 1000, is the steady-state truncation point.

For the [stats_compare](stats_compare.m) function:

* The third parameter specifies the tests to be performed to each of the six
  statistical summaries for each output. In this case were performing the
  _t_-test to all summaries, except **argmax** and **argmin**, to which the
  Mann-Whitney test is applied instead.
* The fourth parameter specifies the significance level for the statistical
  tests.

```matlab
% Get stats data for NetLogo implementation, parameter set 1, all sizes
snl400v1 = stats_gather('NL', [datafolder '/simout/NL'], 'stats400v1r*.txt', 6, 1000);

% Get stats data for the Java implementation, EX strategy (12 threads), parameter set 1, all sizes
sjex400v1 = stats_gather('JEX', [datafolder '/simout/EX'], 'stats400v1pEXt12r*.txt', 6, 1000);

% Perform comparison
[ps, h_all] = stats_compare(snl400v1, sjex400v1, {'t', 'mw', 't', 'mw', 't', 't'}, 0.01);
```

The [stats_compare](stats_compare.m) function return `ps`, a matrix of 
_p_-values for the requested tests (rows correspond to outputs, columns to 
statistical summaries), and `h_all`, containing the number of tests failed for 
the specified significance level.

#### Example 2: Compare focal measures of all Java variants of the PPHPC model

The [stats_compare_many_pw](stats_compare_many_pw.m) function performs pair-wise 
comparisons of multiple model implementations by outputting a table of failed 
tests for each pair of implementations. The following example outputs this table
for all Java variants of the PPHPC model for size 800, parameter set 2:

```matlab
% Get stats data for Java implementation, ST strategy
sjst800v2 = stats_gather('ST', [datafolder '/simout/ST'], 'stats800v2pSTr*.txt', 6, 2000);

% Get stats data for the Java implementation, EQ strategy (12 threads)
sjeql800v2 = stats_gather('EQ', [datafolder '/simout/EQ'], 'stats800v2pEQt12r*.txt', 6, 2000);

% Get stats data for the Java implementation, EX strategy (12 threads)
sjexl800v2 = stats_gather('EX', [datafolder '/simout/EX'], 'stats800v2pEXt12r*.txt', 6, 2000);

% Get stats data for the Java implementation, ER strategy (12 threads)
sjerl800v2 = stats_gather('ER', [datafolder '/simout/ER'], 'stats800v2pERt12r*.txt', 6, 2000);

% Get stats data for the Java implementation, OD strategy (12 threads, b = 500)
sjodl800v2 = stats_gather('OD', [datafolder '/simout/OD'], 'stats800v2pODb500t12r*.txt', 6, 2000);

% Output table of pair-wise failed tests for significance level 0.05
stats_compare_many_pw(0.05, {'t', 'mw', 't', 'mw', 't', 't'}, sjst800v2, sjeql800v2, sjexl800v2, sjerl800v2, sjodl800v2)
```

When comparing multiple model implementations or variants, the 
[stats_compare_many_pw](stats_compare_many_pw.m) function quickly shows if any
of the implementations is misaligned.

#### Example 3: Compare focal measures of all Java variants of the PPHPC model

TODO.

[siunitx]: https://www.ctan.org/pkg/siunitx
[ulem]: https://www.ctan.org/pkg/ulem
[multirow]: https://www.ctan.org/pkg/multirow
[booktabs]: https://www.ctan.org/pkg/booktabs

