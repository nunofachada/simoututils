### Utilities for analyzing simulation output

#### Functions for comparing two or more model implementations

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

