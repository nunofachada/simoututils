### Simulation Model Analysis Utilities

#### Helper functions

* [ci_t](ci_t.m) - Obtain a t-confidence interval.

* [ci_willink](ci_willink.m) - Obtain a Willink confidence interval 
(accounts for skewness).

* [hist_edges](hist_edges.m) - Finds the edges for an histogram (helper 
function used by other functions).

* [is_octave](is_octave.m) - Checks if the code is running in Octave or
Matlab.

* [ltxp](ltxp.m) - Formats a _p_-value for LaTeX using the [ltxpv](ltxpv.m) 
function, setting 'minpv' to `0.001` (i.e. truncating _p_-values to 0.001) and 
'ulims' to `[0 0]` (i.e. disabling underlines).

* [ltxpv](ltxpv.m) - Formats a p-value for LaTeX, using exponents and/or 
truncating very low _p_-values, and underlining/double-underlining _p_-values 
below user specified limits (defaulting to 0.05 for underline and 0.01 for
double-underline). Requires [siunitx] and [ulem] LaTeX packages.

* [ltxr](ltxr.m) - Formats a real value for LaTeX (mainly a helper 
function used by other functions, requires LaTeX [siunitx] package)

* [mavg](mavg.m) - Applies a moving average (low-pass) filter to vector
_x_ using a window of size _w_.

* [parse_output_names](parse_output_names.m) - Determine effective output names
and number of outputs.

* [qqcalc](qqcalc.m) - Calculates the (normalized) points for a QQ-plot 
of the specified sample data versus the normal distribution.

* [tikqq](tikqq.m) - Creates a QQ-plot in TikZ (LaTeX).

* [tikhist](tikhist.m) - Creates an histogram in TikZ (LaTeX).


[siunitx]: https://www.ctan.org/pkg/siunitx
[ulem]: https://www.ctan.org/pkg/ulem
