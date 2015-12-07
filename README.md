Simulation Model Analysis Utilities
===================================

## What are these utilities?

A number of [MATLAB]/[Octave] functions and scripts for analyzing
[output](simout) data from simulation models. These utilities were developed to
analyze the [PPHPC] model, and while some are PPHPC-specific, most can be used 
to study any model.

## How to use them

Start [MATLAB]/[Octave] directly in this folder, or `cd` into this folder and
execute the [startup](startup.m) script:

```
startup
```

The following links describe in detail how to use the utilities:

* [Analysis of simulation output](simout)
* [Comparison of model implementations](compare)
* [Helper functions](helpers)
* [Third-party functions](3rdparty)

## GNU Octave compatibility

These utilities are compatible with GNU Octave. However, note that a number of 
statistical tests provided by Octave return slightly different _p_-values from
those returned by the equivalent MATLAB functions.

## License

[MIT License](LICENSE)

[Matlab]: http://www.mathworks.com/products/matlab/
[Octave]: https://gnu.org/software/octave/
[PPHPC]: https://peerj.com/articles/cs-36/ 
