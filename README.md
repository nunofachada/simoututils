PPHPC Data Analysis Utilities
=============================

# What are these utilities?

A number of [MATLAB]/[Octave] functions and scripts for analysing PPHPC 
simulation outputs.

# Analysis of simulation output

## File format

TSV file (tab-separated values), one column per output, one row per
iteration. Outputs in the following order: sheep population, wolves
population, quantity of available grass, mean sheep energy, mean wolves
energy, mean value of the countdown parameter in all cells.

## Utilities

* [pp_plot](simout/pp_plot.m) - Plot PPHPC simulation output

# License

[MIT License](LICENSE)

[Matlab]: http://www.mathworks.com/products/matlab/
[Octave]: https://gnu.org/software/octave/
[GNU time]: https://www.gnu.org/software/time/
