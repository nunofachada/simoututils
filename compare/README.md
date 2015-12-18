## Comparison of multiple model implementations

### File format

The simulation output file format is the same as in the case of
[analysis of simulation output](../simout), i.e. TSV (tab-separated values), one
column per output, one row per iteration.

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
2. [![DOI](https://zenodo.org/badge/doi/10.5281/zenodo.35240.svg)](http://dx.doi.org/10.5281/zenodo.35240)

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

#### Example 1: Compare focal measures of two model implementations

The [stats_compare](stats_compare.m) function is used to compare focal measures
from two or more model implementations by applying the specified statistical
tests. For this purpose, it uses data obtained with the
[stats_gather](../simout/stats_gather.m) function.

In this example we compare the NetLogo and Java EX implementations of the PPHPC
model for model size 400, parameter set 1. Replications of the Java EX variant
were performed with 12 threads. First, we need to obtain the focal measures
(i.e. statistical summaries of simulation outputs) with the 
[stats_gather](../simout/stats_gather.m) function:

```matlab
% Get stats data for NetLogo implementation, parameter set 1, all sizes
snl400v1 = stats_gather('NL', [datafolder1 '/simout/NL'], 'stats400v1r*.txt', 6, 1000);

% Get stats data for the Java implementation, EX strategy (12 threads), parameter set 1, all sizes
sjex400v1 = stats_gather('JEX', [datafolder1 '/simout/EX'], 'stats400v1pEXt12r*.txt', 6, 1000);
```

As described in [analysis of simulation output](../simout), the 3rd parameter,
6, corresponds to the number of model outputs, while 4th parameter, 1000, is the
steady-state truncation point. We can now perform the comparison using the
[stats_compare](stats_compare.m) function:

```matlab
% Perform comparison
[ps, h_all] = stats_compare(0.01, {'p', 'np', 'p', 'np', 'p', 'p'}, snl400v1, sjex400v1)
```

The 1st parameter specifies the significance level for the statistical tests.
The 2nd parameter specifies the tests to be performed to each of the six 
statistical summaries for each output. In this case we're performing the
_t_-test to all summaries, except **argmax** and **argmin**, to which the
Mann-Whitney test is applied instead. The options 'p' and 'np' stand for
parametric and non-parametric, respectively.

The [stats_compare](stats_compare.m) function return `ps`, a matrix of 
_p_-values for the requested tests (rows correspond to outputs, columns to 
statistical summaries), and `h_all`, containing the number of tests failed for 
the specified significance level.

```
ps =

    0.1784    0.8491    0.4536    1.0000    0.9560    0.1666
    0.0991    0.4727    0.5335    0.0752    0.7231    0.1859
    0.2515    0.3006    0.2312    0.0852    0.8890    0.1683
    0.4685    0.8496    0.9354    1.0000    0.8421    0.4394
    0.7973    0.8796    0.0009    0.3534    0.2200    0.5757
    0.2443    0.0750    0.1719    1.0000    0.9009    0.1680


h_all =

     1
```

#### Example 2: Compare focal measures of multiple model implementations

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
ps = stats_compare(0.05, {'p','np','p','np','p','p'}, sjst800v2, sjeq800v2, sjex800v2, sjer800v2, sjod800v2)
```

```
ps =

    0.8735    0.5325    1.0000    1.0000    0.7132    0.7257
    0.4476    0.9051    0.3624    0.5947    0.7011    0.6554
    0.4227    0.6240    0.8860    0.2442    0.5945    0.6785
    0.0124    0.5474    0.6447    0.5238    0.7038    0.6182
    0.8888    0.9622    0.1410    0.1900    0.7182    0.6825
    0.9306    0.6286    0.4479    0.8377    0.5785    0.6785
```

#### Example 3: Pairwise comparison of model implementations

When comparing multiple model implementations, if one or more are misaligned, 
the [stats_compare](stats_compare.m) function will detected a misalignment, but
will not provide information regarding which implementation is misaligned. The 
[stats_compare_pw](stats_compare_pw.m) function performs pair-wise comparisons 
of multiple model implementations by outputting a table of failed tests for each
pair of implementations, thus allowing to detect which implementation(s) is
(are) misaligned. The following instruction outputs this table for the data used
in the previous example:

```matlab
% Output table of pair-wise failed tests for significance level 0.05
stats_compare_pw(0.05, {'p', 'np', 'p', 'np', 'p', 'p'}, sjst800v2, sjeq800v2, sjex800v2, sjer800v2, sjod800v2)
```

```
             -----------------------------------------------------------------------
             |          ST |          EQ |          EX |          ER |          OD |
------------------------------------------------------------------------------------
|         ST |           0 |           1 |           1 |           1 |           2 |
|         EQ |           1 |           0 |           0 |           0 |           1 |
|         EX |           1 |           0 |           0 |           0 |           0 |
|         ER |           1 |           0 |           0 |           0 |           1 |
|         OD |           2 |           1 |           0 |           1 |           0 |
------------------------------------------------------------------------------------
```

#### Example 4: Plot the PDF and CDF of focal measures from one or more model implementations

In this example we have two PPHPC implementations which produce equivalent
results (NLOK and JEXOK), and two other which display slightly different
behavior (JEXNS and JEXDIFF). The following code loads simulation output data
from these four implementations, and plots, using the 
[stats_compare_plot](stats_compare_plot.m) function, the PDF and CDF of the
respective focal measures. Plots for each focal measure are overlaid, allowing 
the modeler to clearly observe distributional output differences between the 
various implementations.

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

_Sheep population_
![compare_ex04_01](https://cloud.githubusercontent.com/assets/3018963/11904411/d91d552e-a5b7-11e5-8cb2-fcaa8687291d.png)

_Wolf population_
![compare_ex04_02](https://cloud.githubusercontent.com/assets/3018963/11904410/d9180984-a5b7-11e5-9cf2-15d8eeb50a3a.png)

_Quantity of available grass_
![compare_ex04_03](https://cloud.githubusercontent.com/assets/3018963/11904409/d915f0fe-a5b7-11e5-87d8-0577c57265bf.png)

_Mean sheep energy_
![compare_ex04_04](https://cloud.githubusercontent.com/assets/3018963/11904408/d9155f18-a5b7-11e5-9570-95488f6f7642.png)

_Mean wolves energy_
![compare_ex04_05](https://cloud.githubusercontent.com/assets/3018963/11904406/d914c22e-a5b7-11e5-9de4-4226eb2789e4.png)

_Mean value of the countdown parameter in all cells_
![compare_ex04_06](https://cloud.githubusercontent.com/assets/3018963/11904407/d915052c-a5b7-11e5-927a-f8fdc73ac497.png)

More details regarding these four implementations and the specific differences
between them are available in the manuscript 
[Model-independent comparison of simulation output](http://arxiv.org/abs/1509.09174).

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

![compare_ex05](https://cloud.githubusercontent.com/assets/3018963/11904709/e54bee80-a5b9-11e5-9c18-feab61382675.png)

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

![compare_ex06](https://cloud.githubusercontent.com/assets/3018963/11904749/39f23ba6-a5ba-11e5-9f10-d1d42fbd39f8.png)

Here we specify comparison names, I, II, and II, which will be printed in the
table. Note that each comparison tests two model implementations. As such the 
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

![compare_ex07](https://cloud.githubusercontent.com/assets/3018963/11904817/a80b1860-a5ba-11e5-9bb0-38a9ce329b85.png)

We set the `tformat` parameter to 1, as this is more appropriate for larger
number of comparisons.

[siunitx]: https://www.ctan.org/pkg/siunitx
[ulem]: https://www.ctan.org/pkg/ulem
[multirow]: https://www.ctan.org/pkg/multirow
[booktabs]: https://www.ctan.org/pkg/booktabs

