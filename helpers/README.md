### PPHPC Utilities

#### List of helper functions

* [ci_t](ci_t.m) - Obtain a t-confidence interval.

* [ci_willink](ci_willink.m) - Obtain a Willink confidence interval (accounts 
for skewness).

* [hist_edges](hist_edges.m) - Finds the edges for an histogram (helper 
function used by other functions).

* [is_octave](is_octave.m) - Checks if the code is running in Octave or
Matlab.

* [ltxp](ltxp.m) - Formats a p-value for LaTeX, value less than `minpv` are 
formatted to `< minpv` (requires LaTeX [siunitx] package).

* [ltxpe](ltxpe.m) - Formats a p-value for LaTeX, using exponents for very low 
p-values and underlining (double-underlining) values below 0.05 (0.01). Requires
[siunitx] and [ulem] LaTeX packages.

* [ltxr](ltxr.m) - Formats a real value for LaTeX (mainly a helper function used
by other functions, requires LaTeX [siunitx] package)


[siunitx]: https://www.ctan.org/pkg/siunitx
[ulem]: https://www.ctan.org/pkg/ulem