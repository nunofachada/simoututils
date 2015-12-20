## Functions for distributional analysis of output

* [dist_plot_per_fm](dist_plot_per_fm.m) - Plot the distributional properties of 
one focal measure (i.e. of a statistical summary of a single output), namely its
probability density function (estimated), histogram and QQ-plot.

* [dist_table_per_fm](dist_table_per_fm.m) - Outputs a LaTeX table with a 
distributional analysis of a focal measure for a number of 
setups/configurations. For each setup/configuration, the table shows the 
_p_-value of the Shapiro-Wilk test, skewness, histogram and QQ-plot.

* [dist_table_per_setup](dist_table_per_setup.m) - Outputs a LaTeX table with a
distributional analysis of all focal measures for one model setup/configuration.
For each focal measure, the table shows the mean, variance, p-value of the 
Shapiro-Wilk test, skewness, histogram and QQ-plot.

* [stats_table_per_setup](stats_table_per_setup.m) - Outputs a plain text or 
LaTeX table with the statistics returned by the
[stats_analyze](../core/stats_analyze.m) function for all focal measures for one
model setup/configuration.

