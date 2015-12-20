### Simulation Model Analysis Utilities

#### Core functions

* [output_plot](output_plot.m) - Plot time-series simulation output from one or 
more replications using one of three approaches: superimposed, extremes or
moving average.

* [stats_analyze](stats_analyze.m) - Analyze statistical summaries taken from 
simulation output.

* [stats_gather](stats_gather.m) - Get statistical summaries taken from 
simulation outputs from multiple files. The exact statistical summaries depend 
on how the [stats_get](stats_get.m) function is configured.

* [stats_get](stats_get.m) - This is a facade function for `stats_get_*` 
functions. These functions extract statistical summaries from simulation outputs 
from one file. The exact `stats_get_*` function to use is specified within this
function. Two `stats_get_*` functions are included in this package:

  * [stats_get_pphpc](stats_get_pphpc.m) - Obtain the **max**, **argmax**,
    **min**, **argmin**, **mean** and **std** statistical summaries from 
    simulation outputs given in a file (package default).

  * [stats_get_iters](stats_get_iters.m) - Obtain statistical summaries 
    corresponding to output values at user-specified iterations from simulation
    outputs given in a file.

