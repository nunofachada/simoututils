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

* [stats_gather](stats_gather.m) - Get statistical summaries (max, 
argmax, min, argmin, mean, std) taken from simulation outputs from 
multiple files.

* [stats_get](stats_get.m) - Get statistical summaries (max, argmax, 
min, argmin, mean, std) taken from simulation outputs from one file.

#### PPHPC-specific utilities

* [pp_plot](pp_plot.m) - Plot PPHPC simulation output.

* [pp_plot_many](pp_plot_many.m) - Plot PPHPC simulation output from a 
number of runs, either 1) with superimposed outputs, 2) plot filled area 
encompassed by output extremes, or, 3) moving average plot.

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

##### Example 1

TODO

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
