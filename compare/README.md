## Comparison of multiple model implementations

### File format

The simulation output file format is the same as in the case of the
[distributional analysis of simulation output](../simout), i.e. TSV 
(tab-separated values), one column per output, one row per iteration.

### Octave compatibility

Not yet.

### Utilities

#### Generic utilities

* [stats_compare](stats_compare.m) - Compare statistical summaries from 
simulation outputs (i.e. focal measures) from two sets of simulation runs.

#### PPHPC-specific utilities

TODO

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

##### Example 1

TODO

[siunitx]: https://www.ctan.org/pkg/siunitx
[ulem]: https://www.ctan.org/pkg/ulem
[multirow]: https://www.ctan.org/pkg/multirow
[booktabs]: https://www.ctan.org/pkg/booktabs

