## Comparison of multiple model implementations

### File format

The simulation output file format is the same as in the case of the
[distributional analysis of simulation output](../simout), i.e. TSV 
(tab-separated values), one column per output, one row per iteration.

### Utilities

* [stats_compare](stats_compare.m) - Compare focal measures from two or more 
model implementations by applying the specified statistical tests.

* [stats_compare_plot](stats_compare_plot.m) - Plot the probability density 
function (PDF) and cumulative distribution function (CDF) of focal measures from
a number of model implementations.

* [stats_compare_pw](stats_compare_pw.m) - Compare focal measures from 
multiple model implementations, pair-wise, by applying the specified two-sample
statistical tests. This function outputs a plain text table of pair-wise failed
tests.

* [stats_compare_table](stats_compare_table.m) - Output a LaTeX table with 
_p_-values resulting from statistical tests used to evaluate the alignment of 
model implementations.

### Examples

The examples use the following datasets:

1. [![DOI](https://zenodo.org/badge/doi/10.5281/zenodo.34049.svg)](http://dx.doi.org/10.5281/zenodo.34049)
2. [![DOI](https://zenodo.org/badge/doi/10.5281/zenodo.34049.svg)](http://dx.doi.org/10.5281/zenodo.34049)

Dataset 1 corresponds to the results presented in the manuscript
[Parallelization Strategies for Spatial Agent-Based Models](http://arxiv.org/abs/1507.04047),
while dataset 2 corresponds to the results presented in the manuscript
[Model-independent comparison of simulation output](http://arxiv.org/abs/1509.09174).

Unpack the datasets to any folder and put the complete path to these folders in
variables `datafolder1` and `datafolder2`, respectively:

```matlab
datafolder1 = 'path/to/dataset1';
datafolder2 = 'path/to/dataset2';
```

#### Example 1: Compare focal measures of the NetLogo and Java EX implementations of the PPHPC model

Perform comparison using 10 replications of each implementation with model size
400, parameter set 1. Replications of the Java EX variant were performed with 12
threads. For the [stats_gather](stats_gather.m) function:

* The third parameter, 6, corresponds to the number of model outputs. 
Alternatively, a cell array of strings containing the output names could have
been used.
* The fourth parameter, 1000, is the steady-state truncation point.

For the [stats_compare](stats_compare.m) function:

* The first parameter specifies the significance level for the statistical
  tests.
* The second parameter specifies the tests to be performed to each of the six
  statistical summaries for each output. In this case we're performing the
  _t_-test to all summaries, except **argmax** and **argmin**, to which the
  Mann-Whitney test is applied instead. The options 'p' and 'np' stand for 
  parametric and non-parameteric, respectively.
* The remaining parameters are the statistical summaries returned by the
[stats_gather](stats_gather.m) function for the implementations to be compared.

```matlab
% Get stats data for NetLogo implementation, parameter set 1, all sizes
snl400v1 = stats_gather('NL', [datafolder1 '/simout/NL'], 'stats400v1r*.txt', 6, 1000);

% Get stats data for the Java implementation, EX strategy (12 threads), parameter set 1, all sizes
sjex400v1 = stats_gather('JEX', [datafolder1 '/simout/EX'], 'stats400v1pEXt12r*.txt', 6, 1000);

% Perform comparison
[ps, h_all] = stats_compare(0.01, {'p', 'np', 'p', 'np', 'p', 'p'}, snl400v1, sjex400v1);
```

The [stats_compare](stats_compare.m) function return `ps`, a matrix of 
_p_-values for the requested tests (rows correspond to outputs, columns to 
statistical summaries), and `h_all`, containing the number of tests failed for 
the specified significance level.

#### Example 2: Compare focal measures of all Java variants of the PPHPC model

The [stats_compare](stats_compare.m) function also allows to compare focal 
measure from more than two model implementations. If more than two 
[stats_gather](stats_gather.m) structs are passed as arguments, the 
[stats_compare](stats_compare.m) function automatically uses _n_-sample
statistical tests, namely ANOVA as a parametric test, and Kruskal-Wallis as a
non-parametric test. In the following, we compare all Java variants of the PPHPC
model for size 800, parameter set 2:

```matlab
% Get stats data for Java implementation, ST strategy
sjst800v2 = stats_gather('ST', [datafolder1 '/simout/ST'], 'stats800v2pSTr*.txt', 6, 2000);

% Get stats data for the Java implementation, EQ strategy (12 threads)
sjeq800v2 = stats_gather('EQ', [datafolder1 '/simout/EQ'], 'stats800v2pEQt12r*.txt', 6, 2000);

% Get stats data for the Java implementation, EX strategy (12 threads)
sjex800v2 = stats_gather('EX', [datafolder1 '/simout/EX'], 'stats800v2pEXt12r*.txt', 6, 2000);

% Get stats data for the Java implementation, ER strategy (12 threads)
sjer800v2 = stats_gather('ER', [datafolder1 '/simout/ER'], 'stats800v2pERt12r*.txt', 6, 2000);

% Get stats data for the Java implementation, OD strategy (12 threads, b = 500)
sjod800v2 = stats_gather('OD', [datafolder1 '/simout/OD'], 'stats800v2pODb500t12r*.txt', 6, 2000);

% Perform comparison
ps = stats_compare(0.05, {'p','np','p','np','p','p'}, sjst800v2, sjeq800v2, sjex800v2, sjer800v2, sjod800v2);
```

#### Example 3: Pairwise comparison of all Java variants of the PPHPC model

When comparing multiple model implementations, if one or more are misaligned, 
the [stats_compare](stats_compare.m) function will detected a misalignment, but
will not provide information regarding which implementation is misaligned. The 
[stats_compare_pw](stats_compare_pw.m) function performs pair-wise comparisons 
of multiple model implementations by outputting a table of failed tests for each
pair of implementations, thus allowing to detect which implementation(s) is
(are) misaligned. The following example outputs this table for the 
data used in the previous example:

```matlab
% Output table of pair-wise failed tests for significance level 0.05
stats_compare_pw(0.05, {'p', 'np', 'p', 'np', 'p', 'p'}, sjst800v2, sjeq800v2, sjex800v2, sjer800v2, sjod800v2)
```

#### Example 4: Plot the PDF and CDF of focal measures from one or more model implementations

```matlab
% Specify output names
outputs = {'SheepPop', 'WolfPop', 'GrassQty', 'SheepEnergy', 'WolfEnergy', 'GrassEnergy'};

% Determine focal measures of four PPHPC implementations
snl800v2 = stats_gather('NL', [datafolder2 '/nl_ok'], 'stats800v2*.txt', outputs, 2000);
sjexok800v2 = stats_gather('JEXOK', [datafolder2 '/j_ex_ok'], 'stats800v2*.txt', outputs, 2000);
sjexns800v2 = stats_gather('JEXNS', [datafolder2 '/j_ex_noshuff'], 'stats800v2*.txt', outputs, 2000);
sjexdiff800v2 = stats_gather('JEXDIFF', [datafolder2 '/j_ex_diff'], 'stats800v2*.txt', outputs, 2000);

% Plot PDF and CDF of focal measures
stats_compare_plot(snl800v2, sjexok800v2, sjexns800v2, sjexdiff800v2);
```

#### Example 5. Table with _p_-values from comparison of focal measures from model implementations

The [stats_compare_table](stats_compare_table.m) function produces publication
quality tables of _p_-values in LaTeX. This function accepts four parameters:

1. `tests` - Type of statistical tests to perform (parametric or 
non-parametric).
2. `pthresh` - Minimum value of _p_-values before truncation (e.g. if this value
is set to 0.001 and a certain _p_-value is less than that, the table will
display "&lt; 0.001".
3. `tformat` - Specifies if outputs appear in the header (0) or in the first
column (1).
4. `varargin` - Variable number of cell arrays containing the following two
items defining a comparison: 
   * Item 1 can take one of three formats: a) zero, 0, which is an indication 
     not to print any type of comparison name; b) a string describing the 
     comparison name; or, c) a cell array of two strings, the first describing a 
     comparison group name, and the second describing a comparison name.
   * Item 2, a cell array of statistical summaries (given by the 
     [stats_gather](../simout/stats_gather.m) function) of the implementations 
     to be compared.

The following command uses data from example 2 and outputs a table of _p_-values
returned by the non-parametric, multi-sample Kruskal-Wallis test for individual
focal measures:

```matlab
s800v2 = {sjst800v2, sjeq800v2, sjex800v2, sjer800v2, sjod800v2};
stats_compare_table('np', 0.001, 0, {0, s800v2})
```

As we're only performing one comparison (for model size 800, parameter set 2),
the third argument is set to 0. For many comparisons, it is preferable to set
this parameter to 1, as it puts comparisons along columns and outputs along 
rows. The first item in the final argument is set to 0, such that the comparison
name is not printed (which makes sense when the table comprises a single
comparison).

#### Example 6. Multiple comparisons and comparison names

In Table 2 of the [Model-independent comparison...](http://arxiv.org/abs/1509.09174),
manuscript, three comparisons, I, II, and III, are performed. This is 
appropriate for setting the third argument, `tformat`, to 0, as shown in the
following code:

```matlab
% Specify output names
outputs = {'$P^s$', '$P^w$', '$P^c$', '$\overline{E}^s$', '$\overline{E}^w$', '$\overline{C}$'};

% Determine focal measures
snl400v1 = stats_gather('NL', [datafolder2 '/nl_ok'], 'stats400v1*.txt', outputs, 1000);
sjexok400v1 = stats_gather('JEXOK', [datafolder2 '/j_ex_ok'], 'stats400v1*.txt', outputs, 1000);
sjexns400v1 = stats_gather('JEXNS', [datafolder2 '/j_ex_noshuff'], 'stats400v1*.txt', outputs, 1000);
sjexdiff400v1 = stats_gather('JEXDIFF', [datafolder2 '/j_ex_diff'], 'stats400v1*.txt', outputs, 1000);

% Output comparison table
stats_compare_table({'p', 'np', 'p', 'np', 'p', 'p'}, 0.000001, 0, {'I', {snl400v1, sjexok400v1}}, {'II', {snl400v1, sjexns400v1 }}, {'III', {snl400v1, sjexdiff400v1}})
```

Here we specify comparison names, I, II, and II, which will be printed in the
table. Note that, each comparison tests two model implementations. As such the 
resulting _p_-values come from two-sample tests, i.e. from the parametric 
_t_-test and from the non-parametric Mann-Whitney test.

#### Example 7. Comparison groups

In Table 8 of the [Parallelization Strategies...](http://arxiv.org/abs/1507.04047)
manuscript, ten comparisons are performed. Each comparison is associated with a
model size and tests for differences between six model implementations. 
Comparisons are divided into two groups, according to the parameter set used.
This is accomplished by passing a cell array of two strings (comparison group
and comparison name) to the first item of each comparison. The following code 
outputs this table:

```matlab
% Specify output names
outputs = {'$P_i^s$', '$P_i^w$', '$P_i^c$', '$\overline{E}^s_i$', '$\overline{E}^w_i$', '$\overline{C}_i$'};

% Determine focal measures for NetLogo replications
snl100v1 = stats_gather('NL', [datafolder1 '/simout/NL'], 'stats100v1*.txt', outputs, 1000);
snl200v1 = stats_gather('NL', [datafolder1 '/simout/NL'], 'stats200v1*.txt', outputs, 1000);
snl400v1 = stats_gather('NL', [datafolder1 '/simout/NL'], 'stats400v1*.txt', outputs, 1000);
snl800v1 = stats_gather('NL', [datafolder1 '/simout/NL'], 'stats800v1*.txt', outputs, 1000);
snl1600v1 = stats_gather('NL', [datafolder1 '/simout/NL'], 'stats1600v1*.txt', outputs, 1000);
snl100v2 = stats_gather('NL', [datafolder1 '/simout/NL'], 'stats100v2*.txt', outputs, 2000);
snl200v2 = stats_gather('NL', [datafolder1 '/simout/NL'], 'stats200v2*.txt', outputs, 2000);
snl400v2 = stats_gather('NL', [datafolder1 '/simout/NL'], 'stats400v2*.txt', outputs, 2000);
snl800v2 = stats_gather('NL', [datafolder1 '/simout/NL'], 'stats800v2*.txt', outputs, 2000);
snl1600v2 = stats_gather('NL', [datafolder1 '/simout/NL'], 'stats1600v2*.txt', outputs, 2000);

% Determine focal measures for Java ST replications
sjst100v1 = stats_gather('ST', [datafolder1 '/simout/ST'], 'stats100v1*.txt', outputs, 1000);
sjst200v1 = stats_gather('ST', [datafolder1 '/simout/ST'], 'stats200v1*.txt', outputs, 1000);
sjst400v1 = stats_gather('ST', [datafolder1 '/simout/ST'], 'stats400v1*.txt', outputs, 1000);
sjst800v1 = stats_gather('ST', [datafolder1 '/simout/ST'], 'stats800v1*.txt', outputs, 1000);
sjst1600v1 = stats_gather('ST', [datafolder1 '/simout/ST'], 'stats1600v1*.txt', outputs, 1000);
sjst100v2 = stats_gather('ST', [datafolder1 '/simout/ST'], 'stats100v2*.txt', outputs, 2000);
sjst200v2 = stats_gather('ST', [datafolder1 '/simout/ST'], 'stats200v2*.txt', outputs, 2000);
sjst400v2 = stats_gather('ST', [datafolder1 '/simout/ST'], 'stats400v2*.txt', outputs, 2000);
sjst800v2 = stats_gather('ST', [datafolder1 '/simout/ST'], 'stats800v2*.txt', outputs, 2000);
sjst1600v2 = stats_gather('ST', [datafolder1 '/simout/ST'], 'stats1600v2*.txt', outputs, 2000);

% Determine focal measures for Java EQ replications, 12 threads
sjeq100v1 = stats_gather('EQ', [datafolder1 '/simout/EQ'], 'stats100v1pEQt12r*.txt', outputs, 1000);
sjeq200v1 = stats_gather('EQ', [datafolder1 '/simout/EQ'], 'stats200v1pEQt12r*.txt', outputs, 1000);
sjeq400v1 = stats_gather('EQ', [datafolder1 '/simout/EQ'], 'stats400v1pEQt12r*.txt', outputs, 1000);
sjeq800v1 = stats_gather('EQ', [datafolder1 '/simout/EQ'], 'stats800v1pEQt12r*.txt', outputs, 1000);
sjeq1600v1 = stats_gather('EQ', [datafolder1 '/simout/EQ'], 'stats1600v1pEQt12r*.txt', outputs, 1000);
sjeq100v2 = stats_gather('EQ', [datafolder1 '/simout/EQ'], 'stats100v2pEQt12r*.txt', outputs, 2000);
sjeq200v2 = stats_gather('EQ', [datafolder1 '/simout/EQ'], 'stats200v2pEQt12r*.txt', outputs, 2000);
sjeq400v2 = stats_gather('EQ', [datafolder1 '/simout/EQ'], 'stats400v2pEQt12r*.txt', outputs, 2000);
sjeq800v2 = stats_gather('EQ', [datafolder1 '/simout/EQ'], 'stats800v2pEQt12r*.txt', outputs, 2000);
sjeq1600v2 = stats_gather('EQ', [datafolder1 '/simout/EQ'], 'stats1600v2pEQt12r*.txt', outputs, 2000);

% Determine focal measures for Java EX replications, 12 threads
sjex100v1 = stats_gather('EX', [datafolder1 '/simout/EX'], 'stats100v1pEXt12r*.txt', outputs, 1000);
sjex200v1 = stats_gather('EX', [datafolder1 '/simout/EX'], 'stats200v1pEXt12r*.txt', outputs, 1000);
sjex400v1 = stats_gather('EX', [datafolder1 '/simout/EX'], 'stats400v1pEXt12r*.txt', outputs, 1000);
sjex800v1 = stats_gather('EX', [datafolder1 '/simout/EX'], 'stats800v1pEXt12r*.txt', outputs, 1000);
sjex1600v1 = stats_gather('EX', [datafolder1 '/simout/EX'], 'stats1600v1pEXt12r*.txt', outputs, 1000);
sjex100v2 = stats_gather('EX', [datafolder1 '/simout/EX'], 'stats100v2pEXt12r*.txt', outputs, 2000);
sjex200v2 = stats_gather('EX', [datafolder1 '/simout/EX'], 'stats200v2pEXt12r*.txt', outputs, 2000);
sjex400v2 = stats_gather('EX', [datafolder1 '/simout/EX'], 'stats400v2pEXt12r*.txt', outputs, 2000);
sjex800v2 = stats_gather('EX', [datafolder1 '/simout/EX'], 'stats800v2pEXt12r*.txt', outputs, 2000);
sjex1600v2 = stats_gather('EX', [datafolder1 '/simout/EX'], 'stats1600v2pEXt12r*.txt', outputs, 2000);

% Determine focal measures for Java ER replications, 12 threads
sjer100v1 = stats_gather('ER', [datafolder1 '/simout/ER'], 'stats100v1pERt12r*.txt', outputs, 1000);
sjer200v1 = stats_gather('ER', [datafolder1 '/simout/ER'], 'stats200v1pERt12r*.txt', outputs, 1000);
sjer400v1 = stats_gather('ER', [datafolder1 '/simout/ER'], 'stats400v1pERt12r*.txt', outputs, 1000);
sjer800v1 = stats_gather('ER', [datafolder1 '/simout/ER'], 'stats800v1pERt12r*.txt', outputs, 1000);
sjer1600v1 = stats_gather('ER', [datafolder1 '/simout/ER'], 'stats1600v1pERt12r*.txt', outputs, 1000);
sjer100v2 = stats_gather('ER', [datafolder1 '/simout/ER'], 'stats100v2pERt12r*.txt', outputs, 2000);
sjer200v2 = stats_gather('ER', [datafolder1 '/simout/ER'], 'stats200v2pERt12r*.txt', outputs, 2000);
sjer400v2 = stats_gather('ER', [datafolder1 '/simout/ER'], 'stats400v2pERt12r*.txt', outputs, 2000);
sjer800v2 = stats_gather('ER', [datafolder1 '/simout/ER'], 'stats800v2pERt12r*.txt', outputs, 2000);
sjer1600v2 = stats_gather('ER', [datafolder1 '/simout/ER'], 'stats1600v2pERt12r*.txt', outputs, 2000);

% Determine focal measures for Java OD replications, 12 threads, b = 500
sjod100v1 = stats_gather('OD', [datafolder1 '/simout/OD'], 'stats100v1pODb500t12r*.txt', outputs, 1000);
sjod200v1 = stats_gather('OD', [datafolder1 '/simout/OD'], 'stats200v1pODb500t12r*.txt', outputs, 1000);
sjod400v1 = stats_gather('OD', [datafolder1 '/simout/OD'], 'stats400v1pODb500t12r*.txt', outputs, 1000);
sjod800v1 = stats_gather('OD', [datafolder1 '/simout/OD'], 'stats800v1pODb500t12r*.txt', outputs, 1000);
sjod1600v1 = stats_gather('OD', [datafolder1 '/simout/OD'], 'stats1600v1pODb500t12r*.txt', outputs, 1000);
sjod100v2 = stats_gather('OD', [datafolder1 '/simout/OD'], 'stats100v2pODb500t12r*.txt', outputs, 2000);
sjod200v2 = stats_gather('OD', [datafolder1 '/simout/OD'], 'stats200v2pODb500t12r*.txt', outputs, 2000);
sjod400v2 = stats_gather('OD', [datafolder1 '/simout/OD'], 'stats400v2pODb500t12r*.txt', outputs, 2000);
sjod800v2 = stats_gather('OD', [datafolder1 '/simout/OD'], 'stats800v2pODb500t12r*.txt', outputs, 2000);
sjod1600v2 = stats_gather('OD', [datafolder1 '/simout/OD'], 'stats1600v2pODb500t12r*.txt', outputs, 2000);

% Group same size/param.set focal measures into comparisons to be performed
s100v1 = {snl100v1, sjst100v1, sjeq100v1, sjex100v1, sjer100v1, sjod100v1};
s200v1 = {snl200v1, sjst200v1, sjeq200v1, sjex200v1, sjer200v1, sjod200v1};
s400v1 = {snl400v1, sjst400v1, sjeq400v1, sjex400v1, sjer400v1, sjod400v1};
s800v1 = {snl800v1, sjst800v1, sjeq800v1, sjex800v1, sjer800v1, sjod800v1};
s1600v1 = {snl1600v1, sjst1600v1, sjeq1600v1, sjex1600v1, sjer1600v1, sjod1600v1};
s100v2 = {snl100v2, sjst100v2, sjeq100v2, sjex100v2, sjer100v2, sjod100v2};
s200v2 = {snl200v2, sjst200v2, sjeq200v2, sjex200v2, sjer200v2, sjod200v2};
s400v2 = {snl400v2, sjst400v2, sjeq400v2, sjex400v2, sjer400v2, sjod400v2};
s800v2 = {snl800v2, sjst800v2, sjeq800v2, sjex800v2, sjer800v2, sjod800v2};
s1600v2 = {snl1600v2, sjst1600v2, sjeq1600v2, sjex1600v2, sjer1600v2, sjod1600v2};

% Output comparison table
stats_compare_table('np', 0.000001, 1, {{'Param. set 1', '100'}, s100v1}, {{'Param. set 1', '200'}, s200v1}, {{'Param. set 1', '400'}, s400v1}, {{'Param. set 1', '800'}, s800v1}, {{'Param. set 1', '1600'}, s1600v1}, {{'Param. set 2', '100'}, s100v2}, {{'Param. set 2', '200'}, s200v2}, {{'Param. set 2', '400'}, s400v2}, {{'Param. set 2', '800'}, s800v2}, {{'Param. set 2', '1600'}, s1600v2})

```

We set the `tformat` parameter to 1, as this is more appropriate for larger
number of comparisons.


[siunitx]: https://www.ctan.org/pkg/siunitx
[ulem]: https://www.ctan.org/pkg/ulem
[multirow]: https://www.ctan.org/pkg/multirow
[booktabs]: https://www.ctan.org/pkg/booktabs

