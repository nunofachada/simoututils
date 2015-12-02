## Analysis of PPHPC simulation output

### File format

TSV file (tab-separated values), one column per output, one row per
iteration. Outputs in the following order: 

1. Sheep population
2. Wolves population
3. Quantity of available grass
4. Mean sheep energy
5. Mean wolves energy
6. Mean value of the countdown parameter in all cells.

**Example (first 10 lines):**

```
6400	3200	80075	4.509375	20.6634375	2.74455625
5696	3244	85138	5.953476123595506	20.11189889025894	2.433275
5455	3331	90629	6.927956003666361	19.165115580906633	2.123325
5337	3418	96563	7.538504777965149	18.065535400819194	1.81894375
5247	3461	102366	8.146178768820278	17.246460560531638	1.55265
5226	3477	108222	8.66934557979334	16.597354040839804	1.325125
5191	3486	114093	9.277017915623194	15.99885255306942	1.1388875
5206	3500	119900	9.827314636957357	15.338857142857142	0.99003125
5212	3515	125627	10.427091327705295	14.636130867709815	0.88034375
5241	3465	131158	10.964892196145774	14.225396825396825	0.807075
```
### Octave compatibility

All these utilities work in GNU Octave.

### Utilities

#### Generic utilities

* [stats_analyze](stats_analyze.m) - Analyze statistical summaries taken
from simulation output.

* [stats_gather](stats_gather.m) - Get statistical summaries (max, 
argmax, min, argmin, mean, std) taken from simulation outputs from 
multiple files.

* [stats_get](stats_get.m) - Get statistical summaries (max, argmax, 
min, argmin, mean, std) taken from simulation outputs from one file.

* [stats_plotdist](stats_plotdist.m) - Plot the distributional
properties of one focal measure (i.e. of a statistical summary of a 
single output), namely its probability density function (estimated), 
histogram and QQ-plot.

#### PPHPC-specific utilities

* [pp_plot](pp_plot.m) - Plot PPHPC simulation output.

* [pp_plot_many](pp_plot_many.m) - Plot PPHPC simulation output from a 
number of runs, either 1) with superimposed outputs, 2) plot filled area 
encompassed by output extremes, or, 3) moving average plot.

* [pp_stats_analyze_f](pp_stats_analyze_f.m) - Print a table of focal 
measures (obtained with the [stats_analyze](stats_analyze.m) function) 
formatted in plain text or in LaTeX (the latter requires the [siunitx], 
[multirow], [booktabs] and [ulem] packages).

### Examples

#### Distributional output analysis

These examples use the datasets available at 
[![DOI](https://zenodo.org/badge/doi/10.5281/zenodo.34053.svg)](http://dx.doi.org/10.5281/zenodo.34053).
Unpack the datasets to any folder and put the complete path to this 
folder in variable `datafolder`, e.g.:

```matlab
datafolder = 'path/to/datasets';
```

These datasets correspond to the results presented in the article
[Towards a standard model for research in agent-based modeling and simulation](https://peerj.com/articles/cs-36/).

##### Example 1: Plot simulation output

Use the [pp_plot](pp_plot.m) to plot one replication of the PPHPC model:

```matlab
pp_plot([datafolder '/v1/stats100v1r1.txt']);
```

The [pp_plot_many](pp_plot_many.m) function can be used to plot outputs
from multiple replications. It works in three modes. In first mode,
outputs from multiple replications are simply superimposed. This mode is
selected using the 'a' option as the last parameter, as follows:

```matlab
pp_plot_many([datafolder '/v1'], 'stats100v1*.txt', 4001, 'a');
```

The first argument specifies the folder where the simulation output 
files are located, and the second indicates, using wildcards, the 
specific files which contain simulation output. The third argument is
the number of iterations to plot.

The second mode, selected using the 'f' option, allows to plot areas 
limited by output extremes, offering a good perspective on the range of 
values each output takes during simulation runs:

```matlab
pp_plot_many([datafolder '/v1'], 'stats100v1*.txt', 4001, 'f');
```

Finally, the third mode plots the moving average of each output over the 
multiple replications. This mode is selected by passing a positive 
integer as the last argument to the [pp_plot_many](pp_plot_many.m) 
function. This positive integer is the window size with which to smooth
the output. A value of zero is equivalent to no smoothing, i.e. the 
function will simply plot the averaged outputs. A value of 10 offers a
good balance between rough and overly smooth plots:

```matlab
pp_plot_many([datafolder '/v1'], 'stats100v1*.txt', 4001, 10);
```

The third mode of the [pp_plot_many](pp_plot_many.m) function is useful
for empirically selecting a steady-state truncation point.

##### Example 2: Get and analyze statistical summaries taken from simulation output

First, get statistical summaries for 30 runs of the PPHPC model for size
100 and parameter set 1, where 6 corresponds to the number of outputs of
the PPHPC model and 1000 to the iteration after which the outputs are in 
steady-state.

```matlab
s100v1 = stats_gather('100v1', [datafolder '/v1'], 'stats100v1r*.txt', 6, 1000);
```
Six statistical summaries are returned: maximum (**max**), iteration 
where maximum occurs (**argmax**), minimum (**min**), iteration 
where minimum occurs (**argmin**), mean (**mean**), and standard 
deviation (**std**). The **mean** and **std** statistics are obtained
during the steady-state phase of the output.

The [stats_gather](stats_gather.m) returns a _struct_ containing two 
fields: 1) `name` contains the name with which the data was tagged, 
'100v1' in this case; and, 2) `sdata`, a 30 x 36 matrix, with 30
observations (from 30 files) and 36 focal measures (six statistical 
summaries for each of the six outputs).

Let's now analyze the focal measures (i.e. statistical summaries for
each output). The 0.05 value in the second parameter is the significance
level for the confidence intervals and the Shapiro-Wilk test:

```matlab
[m, v, cit, ciw, sw, sk] = stats_analyze(s100v1.sdata', 0.05);
```

The variables returned by the [stats_analyze](stats_analyze.m) function
have 36 rows, one per focal measure. The `m` (mean), `v` (variance), 
`sw` (_p_-value of the Shapiro-Wilk test) and `sk` (skewness) variables
have only one column, i.e. one value per focal measure, while the `cit`
(_t_-confidence interval) and `ciw` (Willink confidence interval)
variables have two columns, which correspond to the lower and upper
limits of the respective intervals.

While the data returned by the [stats_analyze](stats_analyze.m) is in a 
format adequate for further processing and/or analysis, it is not very
human readable. To this purpose, one can use the 
[pp_stats_analyze_f](pp_stats_analyze_f.m) to print a nice plain text
table (the last parameter, 0, specifies plain text output):

```matlab
pp_stats_analyze_f(s100v1.sdata, 0.05, 0);
```

This function can also output a publication quality LaTeX table by 
setting the last argument to 1:

```matlab
pp_stats_analyze_f(s100v1.sdata, 0.05, 1);
```

However, the [pp_stats_analyze_f](pp_stats_analyze_f.m) is not generic,
i.e. it only works with output from PPHPC model.

##### Example 3: Visually analyze the distributional properties of a focal measure

The [stats_plotdist](stats_plotdist.m) function offers a simple way of
assessing the distributional properties of a focal measure for different
model configurations (i.e. different model sizes, different parameter
set, etc). It works with the data returned by the [stats_gather](stats_gather.m)
function. 

* For example, lets assess the distributional properties of the PPHPC
focal measure given by the **argmin** of the _grass quantity_ output for
parameter set 2 and a number of different model sizes:

```matlab
% Get statistical summaries for different model sizes, parameter set 2
s100v2 = stats_gather('100v2', [datafolder '/v2'], 'stats100v2r*.txt', 6, 2000);
s200v2 = stats_gather('200v2', [datafolder '/v2'], 'stats200v2r*.txt', 6, 2000);
s400v2 = stats_gather('400v2', [datafolder '/v2'], 'stats400v2r*.txt', 6, 2000);
s800v2 = stats_gather('800v2', [datafolder '/v2'], 'stats800v2r*.txt', 6, 2000);
s1600v2 = stats_gather('1600v2', [datafolder '/v2'], 'stats1600v2r*.txt', 6, 2000);

% Group them into a cell array
sv2 = {s100v2, s200v2, s400v2, s800v2, s1600v2};

% Plot distributional properties
stats_plotdist(sv2, 3, 4, 'Grass qty.');
```

#### Statistical comparison of multiple implementations

These examples use the datasets available at 
[![DOI](https://zenodo.org/badge/doi/10.5281/zenodo.34049.svg)](http://dx.doi.org/10.5281/zenodo.34049).
Unpack the datasets to any folder and put the complete path to this 
folder in variable `datafolder`, e.g.:

```matlab
datafolder = 'path/to/datasets';
```

These datasets correspond to the results presented in the manuscript
[Parallelization Strategies for Spatial Agent-Based Models](http://arxiv.org/abs/1507.04047).

##### Example 1

TODO

[siunitx]: https://www.ctan.org/pkg/siunitx
[ulem]: https://www.ctan.org/pkg/ulem
[multirow]: https://www.ctan.org/pkg/multirow
[booktabs]: https://www.ctan.org/pkg/booktabs

